class Subject < ActiveRecord::Base
  belongs_to :school
  
  # teacher, assigned to teach the subject
  has_many :users, :through => :subject_teaching_assignments
  has_many :subject_teaching_assignments
  
  has_many :courses
  
  # student, registering for the subject
  has_many :users, :through => :subject_registrations
  has_many :subject_registrations
  
  def teachers
  end
  
  def students_count
    self.subject_registrations.count
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
  
  
end
