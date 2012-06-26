class ApplicationController < ActionController::Base
  include Transloadit::Rails::ParamsDecoder
  protect_from_forgery
  before_filter :authenticate_user!

  layout :layout_by_resource

  def only_role(role_symbol)
    if not current_user.has_role?(role_symbol)
      redirect_to root_url 
    end
  end

  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "devise"
    else
      "application"
    end
  end
  
  
  def after_sign_in_path_for(resource)
    if current_user.has_role?( :school_admin)
      return new_teacher_url
    end
    
    if current_user.has_role?(:teacher)
      return select_subject_for_project_url
    end
    
    if current_user.has_role?(:student)
      return project_submissions_url
    end
  end



  def ensure_has_school_admin_role
    if not current_user.has_role?(:school_admin)
      redirect_to root_url 
    end
  end
  
  def set_breadcrumb_for object, destination_path, opening_words
    # puts "THIS IS WILLLLLY\n"*10
    # puts destination_path
    add_breadcrumb "#{opening_words}", destination_path
  end
  
  
  def has_membership?(  membership_class, membership_provider_id , membership_consumer_id )
    # check the role why do we need to check the role? just check the membership .clear cut. 
    # has the membership? ok, you can see. no membership? you can see the root_url
      # check the ownership 
    membership_class_sym = membership_class.to_s.underscore.to_sym
    provider_property = MEMBERSHIP_DATA[membership_class_sym][:provider_property] 
    consumer_property = MEMBERSHIP_DATA[membership_class_sym][:consumer_property] 
    
    membership = membership_class.send(:find, :first, :conditions => {
      provider_property.to_sym => membership_provider_id , 
      consumer_property.to_sym => membership_consumer_id
    } )
    
    not membership.nil?
  end
  
  def ensure_role(role_sym)
    if not current_user.has_role?(role_sym)
      redirect_to root_url 
      return 
    end
  end
  
  
=begin
  Cleaning out those caching
=end

  def expire_grading_gallery_list_cache( project ) 
    expire_fragment( "gallery_grading_list_#{project.id}"  )
  end
  
  def render_csv(filename = nil)
    filename ||= params[:action]
    filename += '.csv'

    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain" 
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
      headers['Expires'] = "0" 
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
    end

    render :layout => false
  end
  
  
  
  
  protected
  def add_breadcrumb name, url = ''
    @breadcrumbs ||= []
    url = eval(url) if url =~ /_path|_url|@/
    @breadcrumbs << [name, url]
  end

  def self.add_breadcrumb name, url, options = {}
    before_filter options do |controller|
      controller.send(:add_breadcrumb, name, url)
    end
  end
  
end
