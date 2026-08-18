#!/usr/bin/env python3
"""Expose the SLAM map frame to TF without touching Gazebo's base frame.

Hector publishes /nav/robot_pose in nav_map. Gazebo already owns the `base`
TF frame, so this node publishes the same pose as nav_map -> nav_base. RViz
can then select nav_map as a Fixed Frame without competing TF authorities.
"""

import rospy
from geometry_msgs.msg import PoseWithCovarianceStamped
import tf


class PoseBridge:
    def __init__(self):
        self.input_topic = rospy.get_param("~input_topic", "/nav/robot_pose")
        self.child_frame = rospy.get_param("~child_frame", "nav_base")
        self.broadcaster = tf.TransformBroadcaster()
        rospy.Subscriber(self.input_topic, PoseWithCovarianceStamped, self.pose_callback, queue_size=1)
        rospy.loginfo("pose_bridge: %s -> TF child %s", self.input_topic, self.child_frame)

    def pose_callback(self, message):
        pose = message.pose.pose
        self.broadcaster.sendTransform(
            (pose.position.x, pose.position.y, pose.position.z),
            (pose.orientation.x, pose.orientation.y, pose.orientation.z, pose.orientation.w),
            message.header.stamp,
            self.child_frame,
            message.header.frame_id,
        )


if __name__ == "__main__":
    rospy.init_node("nav_pose_bridge")
    PoseBridge()
    rospy.spin()
