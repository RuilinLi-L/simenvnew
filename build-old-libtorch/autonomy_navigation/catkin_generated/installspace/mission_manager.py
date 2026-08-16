#!/usr/bin/env python3
"""Owns the high-level navigation state name.

The stage-1 node only announces readiness. Frontier exploration, door handling
and elevator transitions will be added here without changing other teams'
interfaces.
"""

import rospy
from std_msgs.msg import String


class MissionManager:
    def __init__(self):
        self.status_topic = rospy.get_param("~status_topic", "/nav/mission_status")
        self.publisher = rospy.Publisher(self.status_topic, String, queue_size=1, latch=True)
        self.publisher.publish(String(data="READY: navigation stage 1"))
        rospy.loginfo("mission_manager: navigation stage 1 is ready")


if __name__ == "__main__":
    rospy.init_node("mission_manager")
    MissionManager()
    rospy.spin()
