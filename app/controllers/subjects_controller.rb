class SubjectsController < ApplicationController
  before_filter :ensure_has_school_admin_role
  
  def index
    add_breadcrumb "Pick the subject", 'subjects_path'
    @active_subjects = current_user.get_managed_school.all_active_subjects
  end
  
  def new
    @new_subject  = Subject.new 
    @active_subjects = current_user.get_managed_school.all_active_subjects
  end
  
  def new_subject_teaching_assignment
    @school = current_user.get_managed_school
    @subjects = @school.all_active_subjects
    @teachers = @school.teachers
    add_breadcrumb "Pick the subject", 'new_subject_teaching_assignment'
  end
  
  def create
    @school = current_user.get_managed_school
    @subject = Subject.new(params[:subject])
    
    @starting_date = params[:subject][:starting_date]
    @ending_date = params[:subject][:starting_date]
    
    @subject.starting_date = parse_date(@starting_date) 
    @subject.ending_date = parse_date(@ending_date)
    
    @subject.school_id = @school.id
    @subject.save
    
    redirect_to new_subject_url 
  end
  
  
  
  
=begin
  Managing the HISTORY 
  # assumption => current user is has_role?(:school_admin)
=end

  def active_subjects_management
    @school = current_user.get_managed_school
    @subjects = @school.all_active_subjects
    
    add_breadcrumb "Select the subject", 'active_subjects_management'
  end
  
  
  def passive_subjects_management 
    @school = current_user.get_managed_school
    @subjects = @school.all_passive_subjects
    add_breadcrumb "Select the subject", 'passive_subjects_management'
  end
  
  
  
  def duplicate_active_subject
    duplicate_subject(params)
  end
  
  def duplicate_passive_subject
    duplicate_subject(params)
  end
  
  def duplicate_subject(params)
    @subject = Subject.find_by_id(params[:subject_id])
    @clone_subject = @subject.clone 
    @school = current_user.get_managed_school
    @active_subjects = @school.all_active_subjects
    
    if @subject.is_active == true 
      add_breadcrumb "Select the subject", 'active_subjects_management'
      set_breadcrumb_for @subject, 'duplicate_active_subject_path' + "(#{@subject.id})", 
                  "Create Duplicate"
    else 
      add_breadcrumb "Select the subject", 'passive_subjects_management'
      set_breadcrumb_for @subject, 'duplicate_passive_subject_path' + "(#{@subject.id})", 
                  "Create Duplicate"
    end
    
    
  end
  
  def execute_duplicate_subject 
    @subject = Subject.new(params[:subject])
    @school =  current_user.get_managed_school
    @subject.school_id = @school.id 
    
    # parse the date T_T sigh.. 
    starting_date = params[:subject][:starting_date]
    ending_date  = params[:subject][:ending_date]
    # 02/29/2012
    
    @subject.starting_date = parse_date( starting_date)
    @subject.ending_date = parse_date ( ending_date ) 
   
    if @subject.save
      redirect_to active_subjects_management_url 
    else
      redirect_to duplicate_subject_url( @subject )
    end
  end
  
  def close_subject
    @subject = Subject.find_by_id( params[:entry_id])
    @subject.close_subject
  end
  
  def recover_subject
    @subject=  Subject.find_by_id( params[:entry_id])
    @subject.recover_subject 
  end
  
  
  def select_subject_for_grade_summary
    # as teacher
    # @subject = 
  end
  
  protected
  def parse_date(date)
    date_data  = date.split("/")
    asked_date = Date.civil(date_data[2].to_i,   # year
                  date_data[0].to_i,   # month 
                    date_data[1].to_i )   # day 
                    
    return asked_date 
  end 
  
end
