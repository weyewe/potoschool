class SubjectTeachingAssignment < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user 
  
  
  
  def self.assignment_update( subject_id, user_id, decision )
    # teacher teaches a subject based on subject_teaching_assignment 
    
    if decision == TRUE_CHECK
      # 1. destroy all group membership associated with this studnet in the 
      # current course 
      teaching_assignment = SubjectTeachingAssignment.find(:first, :conditions => {
        :subject_id => subject_id , 
        :user_id => user_id 
      })
      
      if teaching_assignment.nil?
        teaching_assignment = SubjectTeachingAssignment.create :subject_id => subject_id,
                  :user_id => user_id
      end
      
      return teaching_assignment 
      
      # 2. Then, create a new group membership based on the information provided 
    elsif decision == FALSE_CHECK
      # 1. destroy the group membership based on the information provided 
      teaching_assignment = SubjectTeachingAssignment.find(:first, :conditions => {
        :subject_id => subject_id, :user_id => user_id 
      })
      
      if not teaching_assignment.nil?
        teaching_assignment.destroy 
      end
      
      return teaching_assignment
    end
  end
  
  
  def deactivate 
    courses_id = self.subject.courses.select(:id).map{|x| x.id }

    course_teaching_assignments = CourseTeachingAssignment.find(:all, :conditions => {
      :user_id => self.user_id , 
      :course_id => courses_id 
      })

    course_teaching_assignments.each do |course_teaching_assignment|
      course_teaching_assignment.deactivate 
    end

    self.is_active = false
    self.save 
  end
  
  def re_activate 
    courses_id = self.subject.courses.select(:id).map{|x| x.id }

    course_teaching_assignments = CourseTeachingAssignment.find(:all, :conditions => {
      :user_id => self.user_id , 
      :course_id => courses_id 
      })

    course_teaching_assignments.each do |course_teaching_assignment|
      course_teaching_assignment.re_activate 
    end

    self.is_active = true
    self.save 
  end
  
  
end