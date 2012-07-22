class TermsController < ApplicationController
  def new 
    if not current_user.has_role?(:school_admin)
      redirect_to root_url 
    end
    
    @new_term = Term.new 
    @terms = current_school.terms.order("created_at DESC")
  end
  
  
  def create
    if not current_user.has_role?(:school_admin)
      redirect_to root_url 
    end
    if params[:term].nil?
      params[:term]  = {}
    end
    
    @office = current_school
    @new_term = Term.create_term(params[:term], current_user )
    
    if not @new_term.nil? and @new_term.valid?
      flash[:notice] = "The Term '#{@new_term.title}' has been created." 
      redirect_to new_term_url
      return 
    else
      @new_term = Term.new 
      @terms =  current_school.terms.order("created_at DESC")
      flash[:error] = "Hey, do something better"
      
      # add_breadcrumb "Select Machine Category", 'select_machine_category_to_create_machine_url'
      #  set_breadcrumb_for @machine_category, 'new_machine_category_machine_url' + "(#{@machine_category.id})", 
      #              "New Machine"
      render :file => "terms/new"
    end
  end
  
# =begin
#   Create the term
# =end
#   def select_term_to_create_subject
#     @terms  = current_school.active_terms 
#   end

  def execute_close_term
    @term = Term.find_by_id(params[:entity_id])
    
    if current_user.has_role?(:school_admin) and
      @term.school_id == current_school.id
      if params[:action_value].to_i == TRUE_CHECK
        @term.close
      elsif params[:action_value].to_i == FALSE_CHECK
        @term.activate
      end
    end 
 
    
  end
  
end
