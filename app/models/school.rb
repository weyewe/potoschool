class School < ActiveRecord::Base
  has_many :users, :through => :enrollments
  has_many :enrollments
  
  has_many :subjects
  
  
  
  
  def teachers
    teacher_role = Role.find_by_name ROLE_NAME[:teacher]

    self.users.joins(:assignments).where{
      (assignments.role_id == teacher_role.id )
    }
  end
  
  def students
     student_role = Role.find_by_name ROLE_NAME[:student]

     self.users.joins(:assignments).where{
       (assignments.role_id == student_role.id )
     }
     
  end
  
  
end
