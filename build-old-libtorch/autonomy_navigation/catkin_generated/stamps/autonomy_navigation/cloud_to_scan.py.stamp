#!/usr/bin/env python3
"""Project the competition Livox PointCloud into a conservative 2-D LaserScan.

This node intentionally uses the raw /scan topic and the documented fixed
Livox-to-base transform. It does not use Gazebo odometry or ground-truth data.
"""

import math
from collections import deque

import rospy
from sensor_msgs.msg import LaserScan, PointCloud


class CloudToScan:
    def __init__(self):
        self.input_topic = rospy.get_param("~input_cloud_topic", "/scan")
        self.output_topic = rospy.get_param("~output_scan_topic", "/nav/scan2d")
        self.mapping_output_topic = rospy.get_param(
            "~mapping_output_scan_topic", "/nav/scan2d_stable")
        self.output_frame = rospy.get_param("~output_frame", "base")
        self.laser_x = rospy.get_param("~laser_x", 0.20)
        self.laser_y = rospy.get_param("~laser_y", 0.00)
        self.laser_z = rospy.get_param("~laser_z", 0.08)
        self.laser_pitch = rospy.get_param("~laser_pitch", 0.785)
        self.min_z = rospy.get_param("~min_obstacle_z", -0.30)
        self.max_z = rospy.get_param("~max_obstacle_z", 0.80)
        self.range_min = rospy.get_param("~range_min", 0.15)
        self.range_max = rospy.get_param("~range_max", 8.00)
        self.angle_increment = rospy.get_param("~angle_increment", math.radians(1.0))
        # Livox is a non-repetitive 3-D lidar.  A single projected frame can be
        # too sparse for 2-D scan matching, so keep a short history only for
        # mapping.  The current frame remains available for safety.
        self.mapping_window_frames = max(
            1, int(rospy.get_param("~mapping_window_frames", 5)))
        self.mapping_min_samples = max(
            1, int(rospy.get_param("~mapping_min_samples_per_bin", 2)))

        self.angle_min = -math.pi
        self.angle_max = math.pi
        self.bin_count = int(round((self.angle_max - self.angle_min) / self.angle_increment)) + 1
        self.cos_pitch = math.cos(self.laser_pitch)
        self.sin_pitch = math.sin(self.laser_pitch)

        self.publisher = rospy.Publisher(self.output_topic, LaserScan, queue_size=1)
        self.mapping_publisher = rospy.Publisher(
            self.mapping_output_topic, LaserScan, queue_size=1)
        self.range_history = deque(maxlen=self.mapping_window_frames)
        self.subscriber = rospy.Subscriber(self.input_topic, PointCloud, self.callback, queue_size=1)
        rospy.loginfo(
            "cloud_to_scan: %s -> %s (safety), %s (mapping, %d frames)",
            self.input_topic, self.output_topic, self.mapping_output_topic,
            self.mapping_window_frames)

    def callback(self, cloud):
        ranges = [float("inf")] * self.bin_count

        for point in cloud.points:
            # The Gazebo Livox plugin represents a ray with no hit as the
            # sensor-frame origin.  After the fixed transform that becomes a
            # false obstacle at the LiDAR mounting position.
            if point.x * point.x + point.y * point.y + point.z * point.z < 0.05 * 0.05:
                continue

            # Fixed transform: p_base = t_base_laser + R_y(pitch) * p_laser.
            x_base = self.cos_pitch * point.x + self.sin_pitch * point.z + self.laser_x
            y_base = point.y + self.laser_y
            z_base = -self.sin_pitch * point.x + self.cos_pitch * point.z + self.laser_z

            if not (self.min_z <= z_base <= self.max_z):
                continue

            distance = math.hypot(x_base, y_base)
            if distance < self.range_min or distance > self.range_max:
                continue

            angle = math.atan2(y_base, x_base)
            index = int(round((angle - self.angle_min) / self.angle_increment))
            if 0 <= index < self.bin_count and distance < ranges[index]:
                ranges[index] = distance

        self.publisher.publish(self.make_scan(cloud, ranges, 0.1))

        self.range_history.append(ranges)
        stable_ranges = self.make_stable_ranges()
        self.mapping_publisher.publish(
            self.make_scan(cloud, stable_ranges, 0.1 * len(self.range_history)))

    def make_stable_ranges(self):
        """Use the median of a few recent observations in each direction.

        Median removes a one-frame outlier without treating an obstacle that
        appeared in one noisy Livox frame as a wall.  This is deliberately not
        used by safety_guard: safety always receives the newest raw frame.
        """
        stable = [float("inf")] * self.bin_count
        for index in range(self.bin_count):
            samples = [frame[index] for frame in self.range_history
                       if math.isfinite(frame[index])]
            if len(samples) >= self.mapping_min_samples:
                samples.sort()
                middle = len(samples) // 2
                stable[index] = samples[middle]
            elif len(samples) == 1 and len(self.range_history) < self.mapping_min_samples:
                # Give RViz a useful first frame while the history fills up.
                stable[index] = samples[0]
        return stable

    def make_scan(self, cloud, ranges, scan_time):
        scan = LaserScan()
        scan.header.stamp = cloud.header.stamp
        scan.header.frame_id = self.output_frame
        scan.angle_min = self.angle_min
        scan.angle_max = self.angle_max
        scan.angle_increment = self.angle_increment
        scan.time_increment = 0.0
        scan.scan_time = scan_time
        scan.range_min = self.range_min
        scan.range_max = self.range_max
        scan.ranges = ranges
        return scan


if __name__ == "__main__":
    rospy.init_node("cloud_to_scan")
    CloudToScan()
    rospy.spin()
