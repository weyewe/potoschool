class CourseRegistration < ActiveRecord::Base
  belongs_to :user
  belongs_to  :course
  
  
  def self.assignment_update( course_id, user_id, decision )
     # teacher teaches a subject based on subject_teaching_assignment 
     
     subject = Course.find_by_id(course_id).subject 
     
     courses_id  = subject.courses.collect { |x| x.id }
  
     
     
     
     if decision == TRUE_CHECK
       # 1. destroy all course registration associated with this student in the 
       # current subject 
       
       course_registrations = CourseRegistration.find(:all, :conditions => {
         :user_id => user_id, 
         :course_id => courses_id 
       })
       
       course_registrations.each {|x| x.destroy }
       
       course_registration = CourseRegistration.create :user_id => user_id, :course_id => course_id 
       
       return course_registration 

       # 2. Then, create a new group membership based on the information provided 
     elsif decision == FALSE_CHECK
       # 1. destroy the group membership based on the information provided 
       course_registration = CourseRegistration.find(:first, :conditions => {
         :user_id => user_id, :course_id => course_id 
       })

       if not course_registration.nil?
         course_registration.destroy
       end

       return course_registration
     end
   end
  
  
  
end
