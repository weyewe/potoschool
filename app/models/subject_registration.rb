class SubjectRegistration < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user 
  
  
  def self.assignment_update( subject_id, user_id, decision )
    # teacher teaches a subject based on subject_teaching_assignment 
    
    if decision == TRUE_CHECK
      # 1. destroy all group membership associated with this studnet in the 
      # current course 
      subject_registration = SubjectRegistration.find(:first, :conditions => {
        :subject_id => subject_id , 
        :user_id => user_id 
      })
      
      if subject_registration.nil?
        subject_registration = SubjectRegistration.create :subject_id => subject_id,
                  :user_id => user_id
      end
      
      return subject_registration 
      
      # 2. Then, create a new group membership based on the information provided 
    elsif decision == FALSE_CHECK
      # 1. destroy the group membership based on the information provided 
      subject_registration = SubjectRegistration.find(:first, :conditions => {
        :subject_id => subject_id, :user_id => user_id 
      })
      
      if not subject_registration.nil?
        subject_registration.destroy
      end
      
      return subject_registration
    end
  end
  
  
  
  
  def deactivate
    # will only called when the subject is closed ( due to the end of semester )
    #deactivate course registration. Then, deactivate itself 
    
    courses_id = self.subject.courses.select(:id).map{|x| x.id }
    
    course_registrations = CourseRegistration.find(:all, :conditions => {
      :user_id => self.user_id , 
      :course_id => courses_id 
    })
    
    course_registrations.each do |course_registration|
      course_registration.deactivate 
    end
    
    self.is_active = false
    self.save 
    
  end
  
  def re_activate
    courses_id = self.subject.courses.select(:id).map{|x| x.id }
    
    course_registrations = CourseRegistration.find(:all, :conditions => {
      :user_id => self.user_id , 
      :course_id => courses_id 
    })
    
    course_registrations.each do |course_registration|
      course_registration.re_activate 
    end
    
    self.is_active = true 
    self.save
    
  end
  
  
end
