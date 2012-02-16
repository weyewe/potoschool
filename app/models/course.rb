class Course < ActiveRecord::Base
  belongs_to :subject
  
  # teacher has many course through course teaching assignment
  has_many :users, :through => :course_teaching_assignments
  has_many :course_teaching_assignments
  
  
  # student, registering for the course 
  has_many :users, :through => :course_registrations
  has_many :course_registrations
  
  #course has many groups
  has_many :groups
  
  has_many :projects 
  
  
  def teachers_count_for(subject)
    self.course_teaching_assignments.where(:course_id => self.id ).count
  end
end
