class CourseTeachingAssignment < ActiveRecord::Base
  belongs_to :user_id
  belongs_to :course_id
end
