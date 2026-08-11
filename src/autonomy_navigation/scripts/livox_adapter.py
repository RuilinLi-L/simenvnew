#!/usr/bin/env python3
"""Adapt the simulator's raw PointCloud for FAST-LIO without truth odometry.

The simulation publishes a sensor_msgs/PointCloud on /scan.  FAST-LIO uses a
Livox-style CustomMsg because it needs a time offset for every point.  This
node only preserves the raw points and assigns their offsets over one 10 Hz
scan.  It deliberately does not subscribe to odometry, Gazebo state, or any
truth topic.
"""

import rospy
from sensor_msgs.msg import PointCloud
from unitree_guide.msg import CustomMsg, CustomPoint


class LivoxAdapter:
    def __init__(self):
        self.input_topic = rospy.get_param("~input_cloud_topic", "/scan")
        self.output_topic = rospy.get_param("~output_topic", "/nav/livox_custom")
        self.scan_period = float(rospy.get_param("~scan_period", 0.1))
        self.frame_id = rospy.get_param("~frame_id", "laser_livox")
        self.publisher = rospy.Publisher(self.output_topic, CustomMsg, queue_size=3)
        self.subscriber = rospy.Subscriber(
            self.input_topic, PointCloud, self.callback, queue_size=3)
        rospy.loginfo(
            "livox_adapter: %s -> %s (raw LiDAR only, no odometry)",
            self.input_topic, self.output_topic)

    def callback(self, cloud):
        message = CustomMsg()
        message.header.stamp = cloud.header.stamp
        message.header.frame_id = self.frame_id
        message.timebase = cloud.header.stamp.to_nsec()
        message.point_num = len(cloud.points)
        message.lidar_id = 1
        message.rsvd = [0, 0, 0]

        if len(cloud.points) > 1:
            step_ns = int(self.scan_period * 1e9 / (len(cloud.points) - 1))
        else:
            step_ns = 0

        for index, point in enumerate(cloud.points):
            custom_point = CustomPoint()
            custom_point.offset_time = index * step_ns
            custom_point.x = point.x
            custom_point.y = point.y
            custom_point.z = point.z
            custom_point.reflectivity = 0
            custom_point.tag = 0
            custom_point.line = 0
            message.points.append(custom_point)

        self.publisher.publish(message)


if __name__ == "__main__":
    rospy.init_node("nav_livox_adapter")
    LivoxAdapter()
    rospy.spin()
