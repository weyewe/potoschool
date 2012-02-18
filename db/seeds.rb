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

# create test student
(1..30).each do |x|
  user = User.create :email => "test_student_#{x}@potoschool.com", :password => "test_student_#{x}", 
                              :password_confirmation => "test_student_#{x}", 
                              :username => UUIDTools::UUID.timestamp_create.to_s
  user.roles << student_role
  user.save
  school.users << user 
  school.save
end

puts "Done with user creation"
=begin
  Now, we assign the students, teacher, and admin to the school.
  The school will have:
  1 admin
  2 teachers 
  3 students 
=end





=begin
  New methodology: create  the user, add to school (enrollment).
  For each enrollment, create their own role 
=end

# 
# school_admin = User.create :email => "school_admin@potoschool.com", :password => "school_admin", 
#                             :password_confirmation => "school_admin", 
#                             :username => UUIDTools::UUID.timestamp_create.to_s
#           
# teacher_1 = User.create :email => "teacher_1@potoschool.com", :password => "teacher_1", 
#                             :password_confirmation => "teacher_1", 
#                             :username => UUIDTools::UUID.timestamp_create.to_s
# 
# teacher_2 = User.create :email => "teacher_2@potoschool.com", :password => "teacher_2", 
#                             :password_confirmation => "teacher_2", 
#                             :username => UUIDTools::UUID.timestamp_create.to_s
#                             
#                 
# student_1 = User.create :email => "student_1@potoschool.com", :password => "student_1", 
#                             :password_confirmation => "student_1", 
#                             :username => UUIDTools::UUID.timestamp_create.to_s
#                             
#                     
# student_2 = User.create :email => "student_2@potoschool.com", :password => "student_2", 
#                             :password_confirmation => "student_2", 
#                             :username => UUIDTools::UUID.timestamp_create.to_s
#      
#      
# student_3 = User.create :email => "student_3@potoschool.com", :password => "student_3", 
#                             :password_confirmation => "student_3", 
#                             :username => UUIDTools::UUID.timestamp_create.to_s
# 
school.users << student_1
school.users << student_2
school.users << student_3

school.users << teacher_1
school.users << teacher_2
school.users << school_admin
school.save

=begin
Assign the role to each enrollment 

# Question: can a user have more than one enrollment in a given school?
  A student in one class, and a teacher in another class?
    Possible, not common. In the first iteration, assume that it is impossible.
    If he really wnats it, make a new user 
=end
# 
# 
# enrollment = Enrollment.find( :first, :conditions => {:school_id => school.id, :user_id => school_admin.id})
# enrollment.roles << school_admin_role
# enrollment.save
# 
# 
# enrollment = Enrollment.find( :first, :conditions => {:school_id => school.id, :user_id => student_1.id} )
# enrollment.roles << student_role
# enrollment.save
# 
# 
# 
# enrollment = Enrollment.find( :first, :conditions => {:school_id => school.id, :user_id => student_2.id})
# enrollment.roles << student_role
# enrollment.save
# 
# 
# enrollment = Enrollment.find( :first, :conditions => {:school_id => school.id, :user_id => student_3.id} )
# enrollment.roles << student_role
# enrollment.save
# 
# 
# 
# enrollment = Enrollment.find( :first, :conditions => {:school_id => school.id, :user_id => teacher_1.id})
# enrollment.roles << teacher_role
# enrollment.save
# 
# 
# 
# 
# enrollment = Enrollment.find( :first, :conditions => {:school_id => school.id, :user_id => teacher_2.id})
# enrollment.roles << teacher_role
# enrollment.save
# 



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

# subject_1.users << teacher_1 
# subject_1.users << teacher_2
# subject_1.save

puts teacher_1 
puts "before add teacher \n"*10
puts teacher_1.email 
subject_1.add_teacher(  teacher_1 )
puts "after add teacher "
subject_1.add_teacher( teacher_2)

# subject_3.users << teacher_2
# subject_3.save
subject_3.add_teacher( teacher_2 )

puts "after add teacher"

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

# teacher_1.courses << course_1_subject_1
# teacher_1.courses << course_3_subject_1
# teacher_1.courses << course_3_subject_3
# teacher_1.save
puts "before adding teacher to the course"
course_1_subject_1.add_teacher( teacher_1 )
course_3_subject_1.add_teacher( teacher_1 )
course_3_subject_3.add_teacher( teacher_1 )

puts "after add_teacher to the course \n"*10

=begin
  a subject has_many students,   through :subject_registrations
  a subject has_many :subject_registrations 
=end


# subject_1.users <<  student_1
# subject_1.users << student_3 
# subject_1.save
subject_1.add_student( student_1 )
subject_1.add_student( student_3 )


# subject_2.users << student_2
# subject_2.save

subject_2.add_student( student_2)

=begin
  a course has_many students, through :course_registrations
  a course has_many :course_registrations
=end

# course_1_subject_1.users << student_1
# course_1_subject_1.users << student_2
# course_1_subject_1.save

course_1_subject_1.add_student( student_1 )
course_1_subject_1.add_student( student_2 )


(1..30).each do |x|                              
  student = User.find_by_email "test_student_#{x}@potoschool.com"
  course_1_subject_1.add_student( student )
end





=begin
  a course has_many groups, 
  Group has many users :through :group_memberships 
  a group has a leader (a boolean value in the group_membership)
    If there is a group project, only the group leader who can upload the files
=end
# 
# group  = Group.create :course_id => course_1_subject_1.id, :leader_id => nil
# group_membership_1 = GroupMembership.create :group_id => group.id,
#                                 :student_id => student_1.id
#       
      
  
group_1  = course_1_subject_1.create_group( "Group A" )
group_2  = course_1_subject_1.create_group( "Group B" )
group_3  = course_1_subject_1.create_group( "Group C" )

course_1_subject_1.students.each do |x|
  group_1.add_member( x ) 
end
      
# let's create project
project_1 = course_1_subject_1.create_project_with_submissions :title => "This is the first project",
          :description => "Take any picture that you want. Submit it.",
          :deadline_date => DateTime.new( 2013, 3, 4).to_date
          
project_2 = course_1_subject_1.create_project_with_submissions :title => "This is the second project",
          :description => "Take any sexy that you want. Submit it.",
          :deadline_date => DateTime.new( 2012, 5, 4).to_date

    # model this shit tomorrow                          
=begin
 A course has many projects ( can be the type group, or personal )
 The teacher has to post them one by one, for each course
=end
# 
# student_submitter = course_1_subject_1.students.last 
# student_submitter.submit_project( project_1, picture_array )
# student_submitter.submit_revision( original_picture, revision )


=begin
  Ok, we have 2 projects: project_1 and project_2 
  Student has to make submission 
=end

=begin
  A project has many submissions 
  Submission belongs to a user 
=end

=begin
  A submission has many revisions
  revision belongs to a user 
=end


# next task is to adjust the result preview navigation: use prev or next .
=begin
1. get all the original picture id in project_submission.pictures
2. determine the index of the current image 
3. show the next index and prev index
=end








