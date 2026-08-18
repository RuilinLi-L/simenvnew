; Auto-generated. Do not edit!


(cl:in-package autonomy_navigation-msg)


;//! \htmlinclude DangerCandidate.msg.html

(cl:defclass <DangerCandidate> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (position
    :reader position
    :initarg :position
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (confidence
    :reader confidence
    :initarg :confidence
    :type cl:float
    :initform 0.0)
   (target_type
    :reader target_type
    :initarg :target_type
    :type cl:string
    :initform ""))
)

(cl:defclass DangerCandidate (<DangerCandidate>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <DangerCandidate>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'DangerCandidate)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name autonomy_navigation-msg:<DangerCandidate> is deprecated: use autonomy_navigation-msg:DangerCandidate instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <DangerCandidate>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader autonomy_navigation-msg:header-val is deprecated.  Use autonomy_navigation-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'position-val :lambda-list '(m))
(cl:defmethod position-val ((m <DangerCandidate>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader autonomy_navigation-msg:position-val is deprecated.  Use autonomy_navigation-msg:position instead.")
  (position m))

(cl:ensure-generic-function 'confidence-val :lambda-list '(m))
(cl:defmethod confidence-val ((m <DangerCandidate>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader autonomy_navigation-msg:confidence-val is deprecated.  Use autonomy_navigation-msg:confidence instead.")
  (confidence m))

(cl:ensure-generic-function 'target_type-val :lambda-list '(m))
(cl:defmethod target_type-val ((m <DangerCandidate>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader autonomy_navigation-msg:target_type-val is deprecated.  Use autonomy_navigation-msg:target_type instead.")
  (target_type m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DangerCandidate>) ostream)
  "Serializes a message object of type '<DangerCandidate>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'position) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'confidence))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'target_type))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'target_type))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DangerCandidate>) istream)
  "Deserializes a message object of type '<DangerCandidate>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'position) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'confidence) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'target_type) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'target_type) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<DangerCandidate>)))
  "Returns string type for a message object of type '<DangerCandidate>"
  "autonomy_navigation/DangerCandidate")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DangerCandidate)))
  "Returns string type for a message object of type 'DangerCandidate"
  "autonomy_navigation/DangerCandidate")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<DangerCandidate>)))
  "Returns md5sum for a message object of type '<DangerCandidate>"
  "5e795b58e8a82e9507d183a0de0aa73a")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DangerCandidate)))
  "Returns md5sum for a message object of type 'DangerCandidate"
  "5e795b58e8a82e9507d183a0de0aa73a")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DangerCandidate>)))
  "Returns full string definition for message of type '<DangerCandidate>"
  (cl:format cl:nil "# A candidate emitted by the perception component.~%# header.frame_id must identify the coordinate system of position, normally~%# \"real_sense\" or \"base\". position is expressed in that frame.~%~%std_msgs/Header header~%geometry_msgs/Point position~%float32 confidence~%string target_type~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DangerCandidate)))
  "Returns full string definition for message of type 'DangerCandidate"
  (cl:format cl:nil "# A candidate emitted by the perception component.~%# header.frame_id must identify the coordinate system of position, normally~%# \"real_sense\" or \"base\". position is expressed in that frame.~%~%std_msgs/Header header~%geometry_msgs/Point position~%float32 confidence~%string target_type~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DangerCandidate>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'position))
     4
     4 (cl:length (cl:slot-value msg 'target_type))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DangerCandidate>))
  "Converts a ROS message object to a list"
  (cl:list 'DangerCandidate
    (cl:cons ':header (header msg))
    (cl:cons ':position (position msg))
    (cl:cons ':confidence (confidence msg))
    (cl:cons ':target_type (target_type msg))
))
