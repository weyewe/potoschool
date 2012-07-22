class Subject < ActiveRecord::Base
  belongs_to :school
  
  # teacher, assigned to teach the subject
  has_many :users, :through => :subject_teaching_assignments
  has_many :subject_teaching_assignments
  
  has_many :courses
  
  # student, registering for the subject
  has_many :users, :through => :subject_registrations
  has_many :subject_registrations
  
  belongs_to :term 
  
  
  def find_course_by_name( name ) 
    Course.find(:first, :conditions => {
      :name => name.upcase ,
      :subject_id => self.id
    })
  end
  
  def teachers
    # SubjectTeachingAssignment.find(:all, :conditions => {:subject_id => self.id})
    # 
    # self.users.joins(:assignments).where{
    #    (assignments.role_id == student_role.id )
    #  }
    #  
     subject = self 
     User.joins(:subject_teaching_assignments).where{
       (subject_teaching_assignments.subject_id == subject.id )
     }
  end
  
  def students
    self.subject_registrations
    User.where(:id => self.subject_registrations.map{|x| x.user_id }).order("nim DESC")
  end
  
  def students_count
    self.students.count
  end
  
=begin
Teacher code
=end

  def add_teacher(teacher)
    SubjectTeachingAssignment.create :user_id => teacher.id, :subject_id => self.id
  end
  
=begin
Student code
=end

  def add_student( student )
    SubjectRegistration.create :user_id => student.id, :subject_id => self.id
  end
  
  
  
=begin
  Subject school_admin: to close the subject
=end

  def close_subject
    # this is the best done with delayed job 
    # set is active to 
    # 1. Subject Registration
    # 2. Course registration
    # 3. Course Teaching Assignment
    # 4. Subject Teaching Assignment 
    
    self.subject_registrations.each do |subject_registration|
      subject_registration.deactivate
    end
    
    self.subject_teaching_assignments.each do |subject_teaching_assignment|
      subject_teaching_assignment.deactivate
    end
    
    self.is_active = false 
    self.save
  end
  
  
  def recover_subject
    self.subject_registrations.each do |subject_registration|
      subject_registration.re_activate
    end
    
    self.subject_teaching_assignments.each do |subject_teaching_assignment|
      subject_teaching_assignment.re_activate
    end
    
    self.is_active = true 
    self.save 
  end
  
  
  
end
