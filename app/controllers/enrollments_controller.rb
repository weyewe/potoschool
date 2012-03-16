class EnrollmentsController < ApplicationController
  
  before_filter :ensure_has_school_admin_role
  
  # only school_admin that can be here
  def new_teacher
    
    produce_new_enrollment
  end
  
  def new_student
    produce_new_enrollment
  end
  
  
  def create
    role_id = params[:role_id]
    school_id = current_user.school.id 
    
    @enrollment = Enrollment.create_user_with_enrollment( params[:user],params[:enrollment],
                                            school_id, role_id )
                                            
    
    if role_id == Role.find_by_name(ROLE_NAME[:student]).id
      redirect_to new_student_url
      return 
    elsif role_id == Role.find_by_name(ROLE_NAME[:teacher]).id
      redirect_to new_teacher_url
      return 
    end
  end
  
  
  protected
  
  def produce_new_enrollment
    @new_enrollment = Enrollment.new
  end
  

end
