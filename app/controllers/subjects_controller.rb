class SubjectsController < ApplicationController
  before_filter :ensure_has_school_admin_role
  
  def index
    add_breadcrumb "Pick the subject", 'subjects_path'
  end
  
  def new
    @new_subject  = Subject.new 
  end
  
  def new_subject_teaching_assignment
    @school = current_user.get_managed_school
    @subjects = @school.subjects
    @teachers = @school.teachers
    add_breadcrumb "Pick the subject", 'new_subject_teaching_assignment'
  end
  
  def create
    @school = current_user.get_managed_school
    @subject = Subject.new(params[:subject])
    
    @starting_date = params[:subject][:starting_date]
    # 02/29/2012
    time_array = @starting_date.split("/")
    deadline_time = DateTime.civil(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i, 
              DEFAULT_DEADLINE_HOUR, DEFAULT_DEADLINE_MINUTE, 0, 
              # adjust to Jakarta Time +7 -> GMT + 7, out of 24 hours 
              Rational(+7,24) )
              
    @subject.starting_date = deadline_time.getutc # server time is UTC
    
    @ending_date = params[:subject][:ending_date]
    # 02/29/2012
    time_array = @ending_date.split("/")
    deadline_time = DateTime.civil(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i, 
              DEFAULT_DEADLINE_HOUR, DEFAULT_DEADLINE_MINUTE, 0, 
              # adjust to Jakarta Time +7 -> GMT + 7, out of 24 hours 
              Rational(+7,24) )
              
    @subject.ending_date = deadline_time.getutc # server time is UTC
    
    
    @subject.school_id = @school.id
    @subject.save
    
    redirect_to new_subject_url 
    




    
  end
  
end
