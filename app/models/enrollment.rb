class Enrollment < ActiveRecord::Base
  belongs_to :school
  belongs_to :user 
  
  # enrollment
  # has_many :assignments
  #  has_many :roles, :through => :assignments
  
  
  
 
  
  # after_create :send_enrollment_notification

=begin
  Will try to find the user by email. If such user can't be found, then it will 
  create a new user, and send notification 
  
  user_params = { :name => "Ruby Chrissandy", :nim => "", 
        :email => "chrissandyruby@yahoo.com", :password => "ruby1234r", 
        :password_confirmation => "ruby1234r", :username => "rubyc"}
  
  enrollment_params = { :enrollment_code => "coda"}
  school_id = School.last.id
  role_id  = Role.find_by_name("Teacher").id
  
  Enrollment.create_user_with_enrollment( user_params, enrollment_params , school_id, role_id )
  
=end
# creating student has to be by using this method

  def Enrollment.create_user_with_enrollment( user_params, enrollment_params , school_id, role_id )
    password  = UUIDTools::UUID.timestamp_create.to_s[0..7]
    #  we must make sure that there has not been any user with such
    # NIM. If there is any, change the email name , and send password reset 
    school = School.find_by_id school_id 
    @user = school.find_student_by_nim( user_params[:nim] ).nil?
        if not @user.nil? 
          @user.update_with_params( user_params, password )
          return 
        end
    
    
    
    
    @user = User.retrieve_or_create_with_password( user_params, password )
    
    if not @user.nil?
      
      @user.add_role_if_not_exist( role_id )
      @enrollment = Enrollment.create( :user_id => @user.id, :school_id => school_id, 
              :enrollment_code => enrollment_params[:enrollment_code] )
              
              # activate send email
      # User.delay.send_new_registration_notification( @user, password)
              
      return @enrollment
              
      
      
      # after create, send email 
    else
      return nil
    end
  end
  
  
  # def Enrollment.create_user 
   
end
