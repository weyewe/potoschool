desc "Parse student data from google docs"



task :parse_student => :environment do
  
=begin
The following are to parse student / school from nothing  ( no school, no school admin etc)
=end
  require 'csv'
   
   school = School.create :name => "Untar DKV"
   school_admin_role = Role.find_by_name "SchoolAdmin"
   
   
   school_admin = User.create :email => "potoschool.untar@gmail.com", :password => "school_admin1234S", 
                               :password_confirmation => "school_admin1234S", 
                               :username => UUIDTools::UUID.timestamp_create.to_s
   
   school_admin.roles << school_admin_role
   school_admin.save
   
   school.users << school_admin
   school.save
   
   
   fotografi_subject_2 = Subject.create :name => "Fotografi 2", :school_id => school.id
   fotografi_subject_4 = Subject.create :name => "Fotografi 4", :school_id => school.id 
    
   course_2_c = Course.create :name => "C", :subject_id => fotografi_subject_2.id 
   course_2_a = Course.create :name => "A", :subject_id => fotografi_subject_2.id
   course_4_bx = Course.create :name => "BX", :subject_id => fotografi_subject_4.id 
   
   
   student_role = Role.find_by_name "Student"
   SUBJECT_MAP = {
     "2" => fotografi_subject_2,
     "4" => fotografi_subject_4
   }
  
  
                      
=begin
  By this point, we should have had these following variables:
  school
  school_admin
  student_role
  fotografi_subject_2
  fotografi_subject_4
  course_2_a
  course_2_c
  course_4_bx
  SUBJECT_MAP
=end
  
  
  def store_failed_registration( name, email, nim, course_name, subject_name, reason)
    FailedRegistration.create :email => email,
      :nim => nim,
      :name => name, 
      :subject_name => subject_name ,
      :course_name => course_name,
      :reason => reason
  end
  
  filename = "student.csv"
  # filename = "eka_ruby_data.csv"
  CSV.foreach(Rails.root.to_s + "/lib/tasks/" + "#{filename}") do |row|
    
    
    name = row[0]
    email = row[1]
    nim = row[2]
    course = row[3]
    subject_symbol = row[4]
    
    puts "name: #{name}, email: #{email}, nim: #{nim},course: #{course},subject: #{subject_symbol}"
    new_password = UUIDTools::UUID.timestamp_create.to_s[0..7]
    
    puts "creating user"
    new_user_params = {:name => name, 
                :email => email,
                :nim => nim,
                :password => new_password,
                :password_confirmation => new_password,
                :username => UUIDTools::UUID.timestamp_create.to_s}
    new_user = User.new new_user_params

    
    if new_user.valid? 
      
      # User.delay.send_new_registration_notification( new_user, new_password)
      #  Test it 
      puts 'in the save block'
      # school enrollment
      # new_user.add_role_if_not_exist( student_role.id )
      # Enrollment.create( :user_id => new_user.id, :school_id => school.id)
      
      
      enrollment_params = {:enrollment_code => ( User.count + 1)}
      puts "before enrollment create user"
      puts "school: #{school}"
      puts "student_role: #{student_role}"
      enrollment = Enrollment.create_user_with_enrollment( new_user_params, 
                enrollment_params , school.id, student_role.id  )
      puts "after enrollment "
      new_user = enrollment.user
      puts "getting new_user " 
      
      
      fotografi_subject = SUBJECT_MAP[subject_symbol]
      
      course_subject = course.split("-").first
      course_class = course.split("-").last
      
      if course_subject != subject_symbol
        store_failed_registration( name, email, nim, course, subject_symbol, "The Course Symbol is wrong")
      else
        puts "in the subject_symbol_block"
        # assign subject_registration
        SubjectRegistration.create :user_id => new_user.id , :subject_id => fotografi_subject.id 
        # assign course_registration 
        puts "before fotografi_course"
        fotografi_course = Course.find(:first, :conditions=>{:name => course_class, :subject_id => fotografi_subject.id })
        puts "after fotografi_course"
        if fotografi_course.nil?
          store_failed_registration( name, email, nim, course, subject_symbol, "No such course in DB")
        else
          CourseRegistration.create :user_id => new_user.id , :course_id => fotografi_course.id 
        end
        
        #  send email, delayed job
      end
    else
      puts "fail"
      store_failed_registration( name, email, nim, course, subject_symbol, 
      "Basic User Creation Fails #{new_user.errors.messages}")
    end
    
  end
  
  
  FailedRegistration.send_all_failed_registration
  
  
  puts "this is it"
end

task :parse_revision => :environment do
  

require 'csv'

school = School.find_by_id 2 
school_admin = User.find_by_email "potoschool.untar@gmail.com"
student_role = Role.find_by_id   1

fotografi_subject_2  = Subject.find_by_id  4  # this is Fotografi 2
fotografi_subject_4 =  Subject.find_by_id 5
course_2_a = Course.find_by_id 11
course_2_c = Course.find_by_id 10
course_4_bx = Course.find_by_id 12
SUBJECT_MAP = {
  "2" => fotografi_subject_2,
  "4" => fotografi_subject_4
}        


  
  def store_failed_registration( name, email, nim, course_name, subject_name, reason)
    FailedRegistration.create :email => email,
      :nim => nim,
      :name => name, 
      :subject_name => subject_name ,
      :course_name => course_name,
      :reason => reason
  end
  
  filename = "revision_data.csv"
  CSV.foreach(Rails.root.to_s + "/lib/tasks/" + "#{filename}") do |row|
    
    
    name = row[0]
    email = row[1]
    nim = row[2]
    course = row[3]
    subject_symbol = row[4]
    
    puts "name: #{name}, email: #{email}, nim: #{nim},course: #{course},subject: #{subject_symbol}"
    new_password = UUIDTools::UUID.timestamp_create.to_s[0..7]
    
    puts "creating user"
    new_user_params = {:name => name, 
                :email => email,
                :nim => nim,
                :password => new_password,
                :password_confirmation => new_password,
                :username => UUIDTools::UUID.timestamp_create.to_s}
    new_user = User.new new_user_params

    
    if new_user.valid? 
      
      # User.delay.send_new_registration_notification( new_user, new_password)
      #  Test it 
      puts 'in the save block'
      # school enrollment
      # new_user.add_role_if_not_exist( student_role.id )
      # Enrollment.create( :user_id => new_user.id, :school_id => school.id)
      
      
      enrollment_params = {:enrollment_code => ( User.count + 1)}
      puts "before enrollment create user"
      puts "school: #{school}"
      puts "student_role: #{student_role}"
      enrollment = Enrollment.create_user_with_enrollment( new_user_params, 
                enrollment_params , school.id, student_role.id  )
      puts "after enrollment "
      new_user = enrollment.user
      puts "getting new_user " 
      
      
      fotografi_subject = SUBJECT_MAP[subject_symbol]
      
      course_subject = course.split("-").first
      course_class = course.split("-").last
      
      if course_subject != subject_symbol
        store_failed_registration( name, email, nim, course, subject_symbol, "The Course Symbol is wrong")
      else
        puts "in the subject_symbol_block"
        # assign subject_registration
        SubjectRegistration.create :user_id => new_user.id , :subject_id => fotografi_subject.id 
        # assign course_registration 
        puts "before fotografi_course"
        fotografi_course = Course.find(:first, :conditions=>{:name => course_class, :subject_id => fotografi_subject.id })
        puts "after fotografi_course"
        if fotografi_course.nil?
          store_failed_registration( name, email, nim, course, subject_symbol, "No such course in DB")
        else
          CourseRegistration.create :user_id => new_user.id , :course_id => fotografi_course.id 
        end
      end
    else
      puts "fail"
      store_failed_registration( name, email, nim, course, subject_symbol, 
      "Basic User Creation Fails #{new_user.errors.messages}")
    end
  end
  FailedRegistration.send_all_failed_registration
  
end






task :parse_eka_ruby => :environment do
  
  require 'csv'

  school = School.find_by_id 2 
  school_admin = User.find_by_email "potoschool.untar@gmail.com"
  student_role = Role.find_by_id   1

  fotografi_subject_2  = Subject.find_by_id  4  # this is Fotografi 2
  fotografi_subject_4 =  Subject.find_by_id 5
  course_2_a = Course.find_by_id 11
  course_2_c = Course.find_by_id 10
  course_4_bx = Course.find_by_id 12
  SUBJECT_MAP = {
    "2" => fotografi_subject_2,
    "4" => fotografi_subject_4
  }        

                      
=begin
  By this point, we should have had these following variables:
  school
  school_admin
  student_role
  fotografi_subject_2
  fotografi_subject_4
  course_2_a
  course_2_c
  course_4_bx
  SUBJECT_MAP
=end
  
  
  def store_failed_registration( name, email, nim, course_name, subject_name, reason)
    FailedRegistration.create :email => email,
      :nim => nim,
      :name => name, 
      :subject_name => subject_name ,
      :course_name => course_name,
      :reason => reason
  end
  
  filename = "eka_ruby_data.csv"
  CSV.foreach(Rails.root.to_s + "/lib/tasks/" + "#{filename}") do |row|
    
    
    name = row[0]
    email = row[1]
    nim = row[2]
    course = row[3]
    subject_symbol = row[4]
    
    puts "name: #{name}, email: #{email}, nim: #{nim},course: #{course},subject: #{subject_symbol}"
    new_password = UUIDTools::UUID.timestamp_create.to_s[0..7]
    
    puts "creating user"
    new_user_params = {:name => name, 
                :email => email,
                :nim => nim,
                :password => new_password,
                :password_confirmation => new_password,
                :username => UUIDTools::UUID.timestamp_create.to_s}
    new_user = User.new new_user_params

    
    if new_user.valid? 
      
      # User.delay.send_new_registration_notification( new_user, new_password)
      #  Test it 
      puts 'in the save block'
      # school enrollment
      # new_user.add_role_if_not_exist( student_role.id )
      # Enrollment.create( :user_id => new_user.id, :school_id => school.id)
      
      
      enrollment_params = {:enrollment_code => ( User.count + 1)}
      puts "before enrollment create user"
      puts "school: #{school}"
      puts "student_role: #{student_role}"
      enrollment = Enrollment.create_user_with_enrollment( new_user_params, 
                enrollment_params , school.id, student_role.id  )
      puts "after enrollment "
      new_user = enrollment.user
      puts "getting new_user " 
      
      
      fotografi_subject = SUBJECT_MAP[subject_symbol]
      
      course_subject = course.split("-").first
      course_class = course.split("-").last
      
      if course_subject != subject_symbol
        store_failed_registration( name, email, nim, course, subject_symbol, "The Course Symbol is wrong")
      else
        puts "in the subject_symbol_block"
        # assign subject_registration
        SubjectRegistration.create :user_id => new_user.id , :subject_id => fotografi_subject.id 
        # assign course_registration 
        puts "before fotografi_course"
        fotografi_course = Course.find(:first, :conditions=>{:name => course_class, :subject_id => fotografi_subject.id })
        puts "after fotografi_course"
        if fotografi_course.nil?
          store_failed_registration( name, email, nim, course, subject_symbol, "No such course in DB")
        else
          CourseRegistration.create :user_id => new_user.id , :course_id => fotografi_course.id 
        end
        
        #  send email, delayed job
      end
    else
      puts "fail"
      store_failed_registration( name, email, nim, course, subject_symbol, 
      "Basic User Creation Fails #{new_user.errors.messages}")
    end
    
  end
  
  
  FailedRegistration.send_all_failed_registration
  
  
  puts "this is it"
end





