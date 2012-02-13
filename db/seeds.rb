=begin
  The step begins with new School creation.  
  All users belongs to the school. 
  The initial registration will create new role as school admin
  
  We must think of user portability. What if a user is registered for 2 different school?
  No problemo, connected through registration
  
  school has_many users, :through enrollments
  school has_many enrollments
=end

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
                            :password_confirmation => "school_admin"
                            
school_admin.roles << school_admin_role
school_admin.save 

teacher_1 = User.create :email => "teacher_1@potoschool.com", :password => "teacher_1", 
                            :password_confirmation => "teacher_1"
                            
teacher_1.roles << teacher_role
teacher_1.save

student_1 = User.create :email => "student_1@potoschool.com", :password => "student_1", 
                            :password_confirmation => "student_1"
                            
student_1.roles << student_role
student_1.save

student_2 = User.create :email => "student_2@potoschool.com", :password => "student_2", 
                            :password_confirmation => "student_2"
                            
student_2.roles << student_role
student_2.save

student_3 = User.create :email => "student_3@potoschool.com", :password => "student_3", 
                            :password_confirmation => "student_3"
                            
student_3.roles << student_role
student_3.save

=begin
  Now, we assign the students, teacher, and admin to the school.
  The school will have:
  1 admin
  1 teacher 
  3 students 
=end

school.users << student_1
school.users << student_2
school.users << student_3

school.users << teacher_1
school.users << school_admin
school.save 

=begin
  School has many Subjects to begin with, example:
  POTO1111 => beginning photography
  POTO1771  => intermediate photography
  POTO7777 => advanced photography
=end

subject_1 = Subject.create :code => "POTO1111", :name => "Beginning Photography", 
                          :description => "This course will teach you how to use the camera, lens and other things.",
                          :school_id => school.id

subject_2 = Subject.create :code => "POTO1771", :name => "Intermediate Photography", 
                        :description => "Mommy, how can I take that slow motion image, in pseudocolors?",
                        :school_id => school.id
                        
subject_3 = Subject.create :code => "POTO7777", :name => "Advanced Photography", 
                        :description => "Directing the photo object (models, cars, and so on)",
                        :school_id => school.id
                        
                        
=begin
  Subject has_many :teachers, :through => :subject_teaching_assignments
  Subject has_many :subject_teaching_assignments
=end

subject_1.teachers << teacher_1 
subject_1.teachers << teacher_2
subject_1.save

subject_3.teachers << teacher_2
subject_3.save


=begin
  Each Subject is offering several Courses
=end

course_1_subject_1 = Course.create :name => "1-1", :subject_id => subject_1.id
course_2_subject_1 = Course.create :name => "1-2", :subject_id => subject_1.id
course_3_subject_1 = Course.create :name => "1-3", :subject_id => subject_1.id
       
course_1_subject_2 = Course.create :name => "2-1", :subject_id => subject_2.id
course_2_subject_2 = Course.create :name => "2-2", :subject_id => subject_2.id
course_3_subject_2 = Course.create :name => "2-3", :subject_id => subject_2.id
       
course_1_subject_3 = Course.create :name => "3-1", :subject_id => subject_3.id
course_2_subject_3 = Course.create :name => "3-2", :subject_id => subject_3.id
course_3_subject_3 = Course.create :name => "3-3", :subject_id => subject_3.id

=begin
  A teacher might be teaching one or more course
  in a given subject.
  
  teacher has_many :courses, :through => course_teaching_assignments
  teacher has_many :teaching_assignments
=end

teacher_1.courses << course_1_subject_1
teacher_1.courses << course_3_subject_1
teacher_1.courses << course_3_subject_3
teacher_1.save


=begin
  a subject has_many students,   through :subject_registrations
  a subject has_many :subject_registrations 
=end


subject_1.students <<  student_1
subject_1.students << student_3 
subject_1.save

subject_2.students << student_2
subject_2.save

=begin
  a course has_many students, through :course_registrations
  a course has_many :course_registrations
=end

course_1_subject_1.students << student_1
course_1_subject_1.students << student_2
course_1_subject_1.save


=begin
  a course has_many groups, 
  Group has many users :through :group_memberships 
  a group has a leader (a boolean value in the group_membership)
    If there is a group project, only the group leader who can upload the files
=end

group  = Group.create :course_id => course_1_subject_1.id, :leader_id => nil
group_membership_1 = GroupMembership.create :group_id => group.id,
                                :student_id => student_1.id
      
      
      
      
      #model this shit tomorrow                          
=begin
 A course has many projects ( can be the type group, or personal )
 The teacher has to post them one by one, for each course
=end


=begin
  A project has many submissions 
  Submission belongs to a user 
=end

=begin
  A submission has many revisions
  revision belongs to a user 
=end







