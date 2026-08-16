#!/usr/bin/env python3
"""The single publisher from autonomy_navigation to the robot's /cmd_vel.

It clamps commands and stops forward motion when the latest 2-D scan indicates
an obstacle too close or when the scan stream becomes stale.
"""

import math
import threading

import rospy
from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan
from std_msgs.msg import String


def clamp(value, lower, upper):
    return max(lower, min(upper, value))


class SafetyGuard:
    def __init__(self):
        self.input_twist_topic = rospy.get_param("~input_twist_topic", "/nav/cmd_vel_raw")
        self.scan_topic = rospy.get_param("~scan_topic", "/nav/scan2d")
        self.output_twist_topic = rospy.get_param("~output_twist_topic", "/cmd_vel")
        self.status_topic = rospy.get_param("~status_topic", "/nav/status")
        self.publish_rate = rospy.get_param("~publish_rate", 20.0)
        self.command_timeout = rospy.get_param("~command_timeout", 0.30)
        self.scan_timeout = rospy.get_param("~scan_timeout", 0.50)
        self.stop_distance = rospy.get_param("~stop_distance", 0.60)
        self.slow_distance = rospy.get_param("~slow_distance", 1.00)
        self.front_half_angle = rospy.get_param("~front_half_angle", 0.52)
        self.max_linear_x = rospy.get_param("~max_linear_x", 0.35)
        self.max_linear_y = rospy.get_param("~max_linear_y", 0.25)
        self.max_angular_z = rospy.get_param("~max_angular_z", 0.60)

        self.lock = threading.Lock()
        self.latest_command = Twist()
        self.latest_command_time = None
        self.latest_scan_time = None
        self.front_clearance = float("inf")
        self.last_reason = "READY"

        self.publisher = rospy.Publisher(self.output_twist_topic, Twist, queue_size=1)
        self.status_publisher = rospy.Publisher(self.status_topic, String, queue_size=1, latch=True)
        rospy.Subscriber(self.input_twist_topic, Twist, self.command_callback, queue_size=1)
        rospy.Subscriber(self.scan_topic, LaserScan, self.scan_callback, queue_size=1)
        rospy.Timer(rospy.Duration(1.0 / self.publish_rate), self.publish_safe_command)
        self.publish_status("READY: waiting for command and scan")
        rospy.loginfo("safety_guard: %s -> %s", self.input_twist_topic, self.output_twist_topic)

    def command_callback(self, command):
        with self.lock:
            self.latest_command = command
            self.latest_command_time = rospy.Time.now()

    def scan_callback(self, scan):
        nearest = float("inf")
        for index, distance in enumerate(scan.ranges):
            if not math.isfinite(distance):
                continue
            angle = scan.angle_min + index * scan.angle_increment
            if abs(angle) <= self.front_half_angle:
                nearest = min(nearest, distance)
        with self.lock:
            self.front_clearance = nearest
            self.latest_scan_time = rospy.Time.now()

    def publish_status(self, reason):
        if reason != self.last_reason:
            self.last_reason = reason
            self.status_publisher.publish(String(data=reason))
            rospy.loginfo("safety_guard: %s", reason)

    def publish_safe_command(self, _event):
        with self.lock:
            requested = self.latest_command
            latest_command_time = self.latest_command_time
            latest_scan_time = self.latest_scan_time
            clearance = self.front_clearance

        safe = Twist()
        safe.linear.x = clamp(requested.linear.x, -self.max_linear_x, self.max_linear_x)
        safe.linear.y = clamp(requested.linear.y, -self.max_linear_y, self.max_linear_y)
        safe.angular.z = clamp(requested.angular.z, -self.max_angular_z, self.max_angular_z)

        command_is_stale = latest_command_time is None or (rospy.Time.now() - latest_command_time).to_sec() > self.command_timeout
        scan_is_stale = latest_scan_time is None or (rospy.Time.now() - latest_scan_time).to_sec() > self.scan_timeout
        if command_is_stale:
            safe = Twist()
            self.publish_status("SAFETY_STOP: command missing or stale")
        elif scan_is_stale:
            safe = Twist()
            self.publish_status("SAFETY_STOP: scan missing or stale")
        elif requested.linear.x > 0.0 and clearance <= self.stop_distance:
            safe.linear.x = 0.0
            self.publish_status("SAFETY_STOP: obstacle %.2f m ahead" % clearance)
        elif requested.linear.x > 0.0 and clearance < self.slow_distance:
            factor = (clearance - self.stop_distance) / (self.slow_distance - self.stop_distance)
            safe.linear.x *= max(0.0, min(1.0, factor))
            self.publish_status("SAFETY_SLOW: obstacle %.2f m ahead" % clearance)
        else:
            self.publish_status("NAVIGATING")

        self.publisher.publish(safe)


if __name__ == "__main__":
    rospy.init_node("safety_guard")
    SafetyGuard()
    rospy.spin()
