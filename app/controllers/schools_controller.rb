class SchoolsController < ApplicationController
  
  def timezone_setup
    # if current user is not school admin, kick out
    if not current_user.has_role?(:school_admin)
      redirect_to root_url
      return
    end
    
    @school = current_user.get_managed_school
    
  end
  
  def execute_timezone_setup
    
    if not current_user.has_role?(:school_admin)
      redirect_to root_url
      return
    end
    
    @school = current_user.get_managed_school
    
    @school.set_time_zone( params[:school][:time_zone])
    if @school.save 
      flash[:notice] = "Timezone is changed"
    else
      flash[:error] = "Failed to change timezone"
    end
    
    redirect_to timezone_setup_url 
  end
  
end
