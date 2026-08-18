# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "autonomy_navigation: 1 messages, 0 services")

set(MSG_I_FLAGS "-Iautonomy_navigation:/home/ruilinli/SimEnv/src/autonomy_navigation/msg;-Igeometry_msgs:/opt/ros/noetic/share/geometry_msgs/cmake/../msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(autonomy_navigation_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg" NAME_WE)
add_custom_target(_autonomy_navigation_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "autonomy_navigation" "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg" "std_msgs/Header:geometry_msgs/Point"
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(autonomy_navigation
  "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/autonomy_navigation
)

### Generating Services

### Generating Module File
_generate_module_cpp(autonomy_navigation
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/autonomy_navigation
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(autonomy_navigation_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(autonomy_navigation_generate_messages autonomy_navigation_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg" NAME_WE)
add_dependencies(autonomy_navigation_generate_messages_cpp _autonomy_navigation_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(autonomy_navigation_gencpp)
add_dependencies(autonomy_navigation_gencpp autonomy_navigation_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS autonomy_navigation_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(autonomy_navigation
  "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/autonomy_navigation
)

### Generating Services

### Generating Module File
_generate_module_eus(autonomy_navigation
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/autonomy_navigation
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(autonomy_navigation_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(autonomy_navigation_generate_messages autonomy_navigation_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg" NAME_WE)
add_dependencies(autonomy_navigation_generate_messages_eus _autonomy_navigation_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(autonomy_navigation_geneus)
add_dependencies(autonomy_navigation_geneus autonomy_navigation_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS autonomy_navigation_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(autonomy_navigation
  "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/autonomy_navigation
)

### Generating Services

### Generating Module File
_generate_module_lisp(autonomy_navigation
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/autonomy_navigation
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(autonomy_navigation_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(autonomy_navigation_generate_messages autonomy_navigation_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg" NAME_WE)
add_dependencies(autonomy_navigation_generate_messages_lisp _autonomy_navigation_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(autonomy_navigation_genlisp)
add_dependencies(autonomy_navigation_genlisp autonomy_navigation_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS autonomy_navigation_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(autonomy_navigation
  "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/autonomy_navigation
)

### Generating Services

### Generating Module File
_generate_module_nodejs(autonomy_navigation
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/autonomy_navigation
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(autonomy_navigation_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(autonomy_navigation_generate_messages autonomy_navigation_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg" NAME_WE)
add_dependencies(autonomy_navigation_generate_messages_nodejs _autonomy_navigation_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(autonomy_navigation_gennodejs)
add_dependencies(autonomy_navigation_gennodejs autonomy_navigation_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS autonomy_navigation_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(autonomy_navigation
  "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/autonomy_navigation
)

### Generating Services

### Generating Module File
_generate_module_py(autonomy_navigation
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/autonomy_navigation
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(autonomy_navigation_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(autonomy_navigation_generate_messages autonomy_navigation_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/ruilinli/SimEnv/src/autonomy_navigation/msg/DangerCandidate.msg" NAME_WE)
add_dependencies(autonomy_navigation_generate_messages_py _autonomy_navigation_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(autonomy_navigation_genpy)
add_dependencies(autonomy_navigation_genpy autonomy_navigation_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS autonomy_navigation_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/autonomy_navigation)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/autonomy_navigation
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(autonomy_navigation_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(autonomy_navigation_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/autonomy_navigation)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/autonomy_navigation
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(autonomy_navigation_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(autonomy_navigation_generate_messages_eus std_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/autonomy_navigation)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/autonomy_navigation
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(autonomy_navigation_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(autonomy_navigation_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/autonomy_navigation)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/autonomy_navigation
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(autonomy_navigation_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(autonomy_navigation_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/autonomy_navigation)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/autonomy_navigation\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/autonomy_navigation
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(autonomy_navigation_generate_messages_py geometry_msgs_generate_messages_py)
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(autonomy_navigation_generate_messages_py std_msgs_generate_messages_py)
endif()
