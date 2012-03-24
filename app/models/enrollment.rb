class Enrollment < ActiveRecord::Base
  belongs_to :school
  belongs_to :user 
  
  # enrollment
  # has_many :assignments
  #  has_many :roles, :through => :assignments
  
  
  
 
  
  

  def Enrollment.create_user_with_enrollment( user_params, enrollment_params , school_id, role_id )
    @user = User.retrieve_or_create( user_params )
    
    if not @user.nil?
      
      @user.add_role_if_not_exist( role_id )
      return Enrollment.create( :user_id => @user.id, :school_id => school_id, 
              :enrollment_code => enrollment_params[:enrollment_code] )
              
    else
      return nil
    end
  end
   
end
