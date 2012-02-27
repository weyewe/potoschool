class CourseTeachingAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  
  
  
  def self.assignment_update( course_id, user_id, decision )
    # teacher teaches a subject based on subject_teaching_assignment 
    
    if decision == TRUE_CHECK
      # 1. destroy all group membership associated with this studnet in the 
      # current course 
      teaching_assignment = CourseTeachingAssignment.find(:first, :conditions => {
        :course_id => course_id , 
        :user_id => user_id 
      })
      
      if teaching_assignment.nil?
        teaching_assignment = CourseTeachingAssignment.create :course_id => course_id,
                  :user_id => user_id
      end
      
      return teaching_assignment 
      
      # 2. Then, create a new group membership based on the information provided 
    elsif decision == FALSE_CHECK
      # 1. destroy the group membership based on the information provided 
      teaching_assignment = CourseTeachingAssignment.find(:first, :conditions => {
        :course_id => course_id, :user_id => user_id 
      })
      
      if not teaching_assignment.nil?
        teaching_assignment.destroy 
      end
      
      return teaching_assignment
    end
  end
  
  
end
