class School < ActiveRecord::Base
  has_many :users, :through => :enrollments
  has_many :enrollments
  
  has_many :subjects
  
  has_many :failed_registrations
  
=begin
  For setup
=end

  def find_subject_by_code(code)
    Subject.find(:first, :conditions => {
      :school_id => self.id,
      :code => code.upcase 
    })
  end
  
  def find_student_by_nim( nim ) 
    self.students.find_by_nim( nim.upcase )
  end

  
  def teachers
    teacher_role = Role.find_by_name ROLE_NAME[:teacher]

    self.users.includes(:assignments).where{
      (assignments.role_id == teacher_role.id )
    }
  end
  
  def students
     student_role = Role.find_by_name ROLE_NAME[:student]

     self.users.includes(:assignments).where{
       (assignments.role_id == student_role.id )
     }
     
  end
  
  
  def all_active_subjects
    self.subjects.where(:is_active => true ).
                includes(:courses, :subject_registrations ).
                order("created_at DESC")
  end
  
  def all_passive_subjects
    self.subjects.where(:is_active => false ).
                includes(:courses, :subject_registrations ).
                order("created_at DESC")
  end
  
  
  def send_total_statistic
    self.subjects.each do |subject|
      subject.courses.each do |course|
        NewsletterMailer.send_statistic(course,subject).deliver
      end
    end
  end
  
  def set_time_zone( time_zone)
    self.time_zone = time_zone
    self.save
  end
  
end
