#!/usr/bin/env python3
"""Expose FAST-LIO odometry through the navigation module's stable API."""

import rospy
import tf
from geometry_msgs.msg import PoseWithCovarianceStamped
from nav_msgs.msg import Odometry


class LioPoseBridge:
    def __init__(self):
        self.input_topic = rospy.get_param("~input_topic", "/nav/lio_odom")
        self.output_topic = rospy.get_param("~output_topic", "/nav/robot_pose")
        self.map_frame = rospy.get_param("~map_frame", "nav_lio_map")
        # FAST-LIO calls its own map frame "camera_init". Keep that frame for
        # its PointCloud2 outputs and attach it to the public nav_lio_map frame.
        self.lio_map_frame = rospy.get_param("~lio_map_frame", "camera_init")
        self.base_frame = rospy.get_param("~base_frame", "nav_lio_base")
        self.publisher = rospy.Publisher(
            self.output_topic, PoseWithCovarianceStamped, queue_size=10)
        self.broadcaster = tf.TransformBroadcaster()
        self.subscriber = rospy.Subscriber(
            self.input_topic, Odometry, self.callback, queue_size=10)
        rospy.loginfo("lio_pose_bridge: %s -> %s", self.input_topic, self.output_topic)

    def callback(self, odom):
        pose = PoseWithCovarianceStamped()
        pose.header.stamp = odom.header.stamp
        pose.header.frame_id = self.map_frame
        pose.pose = odom.pose
        self.publisher.publish(pose)

        self.broadcaster.sendTransform(
            (0.0, 0.0, 0.0),
            (0.0, 0.0, 0.0, 1.0),
            odom.header.stamp,
            self.lio_map_frame,
            self.map_frame)

        position = odom.pose.pose.position
        orientation = odom.pose.pose.orientation
        self.broadcaster.sendTransform(
            (position.x, position.y, position.z),
            (orientation.x, orientation.y, orientation.z, orientation.w),
            odom.header.stamp,
            self.base_frame,
            self.map_frame)


if __name__ == "__main__":
    rospy.init_node("nav_lio_pose_bridge")
    LioPoseBridge()
    rospy.spin()
