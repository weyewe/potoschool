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
  
  
  
  
end
