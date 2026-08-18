
(cl:in-package :asdf)

(defsystem "autonomy_navigation-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "DangerCandidate" :depends-on ("_package_DangerCandidate"))
    (:file "_package_DangerCandidate" :depends-on ("_package"))
  ))