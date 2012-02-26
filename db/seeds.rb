
school = School.create :name => "Untar DKV"

=begin
  Now, we have to create the user. User has the role of 
    1. Student
    2. Teacher 
    3. SchoolAdmin
=end

student_role = Role.create :name => "Student"
teacher_role = Role.create :name => "Teacher"
school_admin_role = Role.create :name => "SchoolAdmin"

=begin
  After the user role has been created, we will continue with the user creation.
=end

school_admin = User.create :email => "school_admin@potoschool.com", :password => "school_admin", 
                            :password_confirmation => "school_admin", 
                            :username => UUIDTools::UUID.timestamp_create.to_s
                            
school_admin.roles << school_admin_role
school_admin.save 

teacher_1 = User.create :email => "teacher_1@potoschool.com", :password => "teacher_1", 
                            :password_confirmation => "teacher_1", 
                            :username => UUIDTools::UUID.timestamp_create.to_s
 
teacher_2 = User.create :email => "teacher_2@potoschool.com", :password => "teacher_2", 
                            :password_confirmation => "teacher_2", 
                            :username => UUIDTools::UUID.timestamp_create.to_s
                            
teacher_1.roles << teacher_role
teacher_1.save

teacher_2.roles << teacher_role
teacher_2.save

student_1 = User.create :email => "student_1@potoschool.com", :password => "student_1", 
                            :password_confirmation => "student_1", 
                            :username => UUIDTools::UUID.timestamp_create.to_s
                            
student_1.roles << student_role
student_1.save

student_2 = User.create :email => "student_2@potoschool.com", :password => "student_2", 
                            :password_confirmation => "student_2", 
                            :username => UUIDTools::UUID.timestamp_create.to_s
                            
student_2.roles << student_role
student_2.save

student_3 = User.create :email => "student_3@potoschool.com", :password => "student_3", 
                            :password_confirmation => "student_3", 
                            :username => UUIDTools::UUID.timestamp_create.to_s
                            
student_3.roles << student_role
student_3.save


school.users << student_1
school.users << student_2
school.users << student_3

school.users << teacher_1
school.users << teacher_2
school.users << school_admin
school.save


=begin
  This is the minimum seeds. Subject, Project, Course has to be made by the school_admin 
  3 students. 2 teachers 
  1 admin. just nice
=end