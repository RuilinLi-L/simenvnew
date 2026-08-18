;; Auto-generated. Do not edit!


(when (boundp 'autonomy_navigation::DangerCandidate)
  (if (not (find-package "AUTONOMY_NAVIGATION"))
    (make-package "AUTONOMY_NAVIGATION"))
  (shadow 'DangerCandidate (find-package "AUTONOMY_NAVIGATION")))
(unless (find-package "AUTONOMY_NAVIGATION::DANGERCANDIDATE")
  (make-package "AUTONOMY_NAVIGATION::DANGERCANDIDATE"))

(in-package "ROS")
;;//! \htmlinclude DangerCandidate.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass autonomy_navigation::DangerCandidate
  :super ros::object
  :slots (_header _position _confidence _target_type ))

(defmethod autonomy_navigation::DangerCandidate
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:position __position) (instance geometry_msgs::Point :init))
    ((:confidence __confidence) 0.0)
    ((:target_type __target_type) "")
    )
   (send-super :init)
   (setq _header __header)
   (setq _position __position)
   (setq _confidence (float __confidence))
   (setq _target_type (string __target_type))
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:position
   (&rest __position)
   (if (keywordp (car __position))
       (send* _position __position)
     (progn
       (if __position (setq _position (car __position)))
       _position)))
  (:confidence
   (&optional __confidence)
   (if __confidence (setq _confidence __confidence)) _confidence)
  (:target_type
   (&optional __target_type)
   (if __target_type (setq _target_type __target_type)) _target_type)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; geometry_msgs/Point _position
    (send _position :serialization-length)
    ;; float32 _confidence
    4
    ;; string _target_type
    4 (length _target_type)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; geometry_msgs/Point _position
       (send _position :serialize s)
     ;; float32 _confidence
       (sys::poke _confidence (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; string _target_type
       (write-long (length _target_type) s) (princ _target_type s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; geometry_msgs/Point _position
     (send _position :deserialize buf ptr-) (incf ptr- (send _position :serialization-length))
   ;; float32 _confidence
     (setq _confidence (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; string _target_type
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _target_type (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(setf (get autonomy_navigation::DangerCandidate :md5sum-) "5e795b58e8a82e9507d183a0de0aa73a")
(setf (get autonomy_navigation::DangerCandidate :datatype-) "autonomy_navigation/DangerCandidate")
(setf (get autonomy_navigation::DangerCandidate :definition-)
      "# A candidate emitted by the perception component.
# header.frame_id must identify the coordinate system of position, normally
# \"real_sense\" or \"base\". position is expressed in that frame.

std_msgs/Header header
geometry_msgs/Point position
float32 confidence
string target_type

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

")



(provide :autonomy_navigation/DangerCandidate "5e795b58e8a82e9507d183a0de0aa73a")


