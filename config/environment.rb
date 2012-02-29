# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Debita46::Application.initialize!

ROLE_NAME = {
  :student => "Student",
  :teacher => "Teacher", 
  :school_admin => "SchoolAdmin" 
}


TRUE_CHECK = 1
FALSE_CHECK = 0


ORIGINAL_PICTURE   = 1
REVISION_PICTURE   = 0

NORMAL_COMMENT     = 0
POSITIONAL_COMMENT = 1

ACCEPT_SUBMISSION = 1
REJECT_SUBMISSION = 0

ADD_GROUP_LEADER = 1 
REMOVE_GROUP_LEADER = 0

DEFAULT_DEADLINE_HOUR = 23
DEFAULT_DEADLINE_MINUTE = 59 


DISPLAY_IMAGE_WIDTH = 590

EVENT_TYPE  = {
  :create_comment => 1,  # yes
  :reply_comment => 2,  # yes 
  :submit_picture => 3 ,   #added
  :submit_picture_revision => 4,  #added 
  :grade_picture => 5,  # added   # rejected and approved 
  :create_project => 6   #added
}
# 
# SECONDARY_SUBJECT_EVENT = [ 2, 4 , 5 ] # reply, revision, grade picture  
