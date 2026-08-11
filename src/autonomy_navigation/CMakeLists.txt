cmake_minimum_required(VERSION 3.0.2)
project(autonomy_navigation)

find_package(catkin REQUIRED COMPONENTS
  geometry_msgs
  message_generation
  nav_msgs
  rospy
  sensor_msgs
  std_msgs
)

add_message_files(
  FILES
  DangerCandidate.msg
)

generate_messages(
  DEPENDENCIES
  geometry_msgs
  std_msgs
)

catkin_package(
  CATKIN_DEPENDS
    geometry_msgs
    message_runtime
    nav_msgs
    rospy
    sensor_msgs
    std_msgs
)

catkin_install_python(PROGRAMS
  scripts/cloud_to_scan.py
  scripts/livox_adapter.py
  scripts/lio_pose_bridge.py
  scripts/safety_guard.py
  scripts/mission_manager.py
  scripts/pose_bridge.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(DIRECTORY config launch
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
