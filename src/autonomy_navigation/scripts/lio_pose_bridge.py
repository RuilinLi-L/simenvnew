#!/usr/bin/env python3
"""Expose FAST-LIO's IMU pose as the robot-base pose.

FAST-LIO publishes the pose of its ``body`` state, which is the Livox IMU in
this simulation.  The LiDAR/IMU is mounted forward and pitched relative to the
robot base, so relabelling that pose as a base pose creates a position and yaw
bias.  This bridge applies the fixed TF extrinsic before publishing.
"""

import rospy
import tf2_ros
from tf.transformations import (
    concatenate_matrices,
    inverse_matrix,
    quaternion_from_matrix,
    quaternion_matrix,
    translation_from_matrix,
    translation_matrix,
)
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
        self.robot_base_frame = rospy.get_param("~robot_base_frame", "base")
        self.tracking_frame = rospy.get_param(
            "~tracking_frame", "livox_imu_link"
        )
        self.publisher = rospy.Publisher(
            self.output_topic, PoseWithCovarianceStamped, queue_size=10)
        self.tf_buffer = tf2_ros.Buffer(cache_time=rospy.Duration(10.0))
        self.tf_listener = tf2_ros.TransformListener(self.tf_buffer)
        self.broadcaster = tf2_ros.TransformBroadcaster()
        self.subscriber = rospy.Subscriber(
            self.input_topic, Odometry, self.callback, queue_size=10)
        rospy.loginfo(
            "lio_pose_bridge: %s -> %s (%s pose corrected to %s)",
            self.input_topic, self.output_topic, self.tracking_frame,
            self.robot_base_frame)

    def callback(self, odom):
        try:
            base_from_tracking = self.tf_buffer.lookup_transform(
                self.robot_base_frame, self.tracking_frame, rospy.Time(0),
                rospy.Duration(0.1))
        except (
            tf2_ros.LookupException,
            tf2_ros.ConnectivityException,
            tf2_ros.ExtrapolationException,
        ) as exc:
            rospy.logwarn_throttle(
                1.0, "lio_pose_bridge: TF %s <- %s unavailable: %s",
                self.robot_base_frame, self.tracking_frame, exc)
            return

        position = odom.pose.pose.position
        orientation = odom.pose.pose.orientation
        tracking_from_base = self._matrix_from_transform(
            base_from_tracking.transform
        )
        map_from_tracking = concatenate_matrices(
            translation_matrix((position.x, position.y, position.z)),
            quaternion_matrix((
                orientation.x, orientation.y, orientation.z, orientation.w,
            )),
        )
        map_from_base = concatenate_matrices(
            map_from_tracking, inverse_matrix(tracking_from_base)
        )
        base_translation = translation_from_matrix(map_from_base)
        base_rotation = quaternion_from_matrix(map_from_base)

        pose = PoseWithCovarianceStamped()
        pose.header.stamp = odom.header.stamp
        pose.header.frame_id = self.map_frame
        pose.pose.covariance = odom.pose.covariance
        pose.pose.pose.position.x = base_translation[0]
        pose.pose.pose.position.y = base_translation[1]
        pose.pose.pose.position.z = base_translation[2]
        pose.pose.pose.orientation.x = base_rotation[0]
        pose.pose.pose.orientation.y = base_rotation[1]
        pose.pose.pose.orientation.z = base_rotation[2]
        pose.pose.pose.orientation.w = base_rotation[3]
        self.publisher.publish(pose)

        self.broadcaster.sendTransform([
            self._transform(
                self.map_frame, self.lio_map_frame, odom.header.stamp,
                (0.0, 0.0, 0.0), (0.0, 0.0, 0.0, 1.0)),
            self._transform(
                self.map_frame, self.base_frame, odom.header.stamp,
                base_translation, base_rotation),
        ])

    @staticmethod
    def _matrix_from_transform(transform):
        translation = transform.translation
        rotation = transform.rotation
        return concatenate_matrices(
            translation_matrix((translation.x, translation.y, translation.z)),
            quaternion_matrix((rotation.x, rotation.y, rotation.z, rotation.w)),
        )

    @staticmethod
    def _transform(parent, child, stamp, translation, rotation):
        from geometry_msgs.msg import TransformStamped

        transform = TransformStamped()
        transform.header.stamp = stamp
        transform.header.frame_id = parent
        transform.child_frame_id = child
        transform.transform.translation.x = translation[0]
        transform.transform.translation.y = translation[1]
        transform.transform.translation.z = translation[2]
        transform.transform.rotation.x = rotation[0]
        transform.transform.rotation.y = rotation[1]
        transform.transform.rotation.z = rotation[2]
        transform.transform.rotation.w = rotation[3]
        return transform


if __name__ == "__main__":
    rospy.init_node("nav_lio_pose_bridge")
    LioPoseBridge()
    rospy.spin()
