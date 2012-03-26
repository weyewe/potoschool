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
  
  user_params = { :name => "Kurnia Setiawan", :nim => "", 
        :email => "kurniast@yahoo.com", :password => "kunia1234k", 
        :password_confirmation => "kunia1234k", :username => "kurniast"}
  
  enrollment_params = { :enrollment_code => "coda"}
  school_id = School.last.id
  role_id  = Role.find_by_name("Teacher").id
  
  Enrollment.create_user_with_enrollment( user_params, enrollment_params , school_id, role_id )
  
=end


  def Enrollment.create_user_with_enrollment( user_params, enrollment_params , school_id, role_id )
    password  = UUIDTools::UUID.timestamp_create.to_s[0..7]
    @user = User.retrieve_or_create_with_password( user_params, password )
    
    if not @user.nil?
      
      @user.add_role_if_not_exist( role_id )
      @enrollment = Enrollment.create( :user_id => @user.id, :school_id => school_id, 
              :enrollment_code => enrollment_params[:enrollment_code] )
              
      User.delay.send_new_registration_notification( @user, password)
              
      return @enrollment
              
      
      
      # after create, send email 
    else
      return nil
    end
  end
  
  
  # def Enrollment.create_user 
   
end
