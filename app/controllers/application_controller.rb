class ApplicationController < ActionController::Base
  include Transloadit::Rails::ParamsDecoder
  protect_from_forgery
  before_filter :authenticate_user!

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "devise"
    else
      "application"
    end
  end
  
  
  def after_sign_in_path_for(resource)
    dashboard_url 
  end



  def ensure_has_school_admin_role
    if not current_user.has_role?(:school_admin)
      redirect_to root_url 
    end
  end
  
end
