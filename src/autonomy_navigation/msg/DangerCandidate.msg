# A candidate emitted by the perception component.
# header.frame_id must identify the coordinate system of position, normally
# "real_sense" or "base". position is expressed in that frame.

std_msgs/Header header
geometry_msgs/Point position
float32 confidence
string target_type
