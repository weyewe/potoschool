class HomeController < ApplicationController
  # skip_filter :authenticate_user!, :only => [ :dashboard]
  
  def dashboard
    if current_user.has_role?( :school_admin)
      redirect_to new_teacher_url 
      return 
    end
    
    if current_user.has_role?(:teacher)
      redirect_to select_subject_for_project_url 
      return
    end
    
    if current_user.has_role?(:student)
      redirect_to project_submissions_url 
      return
    end
  end
  
end
