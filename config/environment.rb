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


ORIGINAL_PICTURE = 1
REVISION_PICTURE = 0



