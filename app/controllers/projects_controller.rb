class ProjectsController < ApplicationController
  
  def select_subject_for_project
    # list all subjects assigned to the teacher
    add_breadcrumb "Select Subject", "select_subject_for_project_url"
    
    # we assume that only teacher who is  logged in, in this section
    @teacher = current_user
    @subjects = @teacher.all_subjects_taught
    
  end
  
  def select_course_for_project
    # list all courses for the assigned subjects
    # currnet user is a teacher
    @subject = Subject.find_by_id( params[:subject_id])
    @courses = current_user.all_courses_for_subject( @subject )
    
    add_breadcrumb "Select Subject", "select_subject_for_project_url"
    set_breadcrumb_for @subject, 'select_course_for_project_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"

    
  end
  
  def new 
    # ensure_current_user_is_related( :teacher )
    # ensure_role(:teacher)
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @course = Course.find_by_id( params[:course_id])
    if not current_user.teach_course?(@course)
      redirect_to root_url 
      return 
    end
    
    @subject = @course.subject
    @new_project = Project.new
    
    @projects = @course.projects
    
    add_breadcrumb "Select Subject", "select_subject_for_project_url"
    set_breadcrumb_for @subject, 'select_course_for_project_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"
    set_breadcrumb_for @course, 'new_course_project_path' + "(#{@course.id})", 
                "Create Project"       
  end
  
  def select_active_project_to_be_edited
    # ensure_role(:teacher)
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    # current_user is teacher 
    @projects = current_user.all_active_projects
    
    add_breadcrumb "Select Project", "select_active_project_to_be_edited_url"
  end
  
  
  def edit
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    # current_user is teacher 
    @project = Project.find_by_id params[:id]
    @course = @project.course
    @subject = @course.subject
    @projects = current_user.all_active_projects
    
    
    add_breadcrumb "Select Project", "select_active_project_to_be_edited_url"
  end
  
  def update
    @project = Project.find_by_id params[:id]
    @course = @project.course
    @subject = @course.subject
    @projects = current_user.all_active_projects
    
    
    @project.update_attributes( params[:project] )
    @project.deadline_datetime = extract_deadline_time( params[:project][:deadline_datetime])
    @project.save 
  
    add_breadcrumb "Select Project", "select_active_project_to_be_edited_url"
  end
  
  def create
    # ensure_role(:teacher)
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @course = Course.find_by_id( params[:course_id])
    
    if not current_user.teach_course?(@course)
      redirect_to root_url 
      return
    end
    
    
    @project = Project.new( params[:project])
    @project.course_id = @course.id
    if params[:project][:is_group_project].to_i == TRUE_CHECK
      @project.is_group_project = true 
    else
      @project.is_group_project = false 
    end
  
    # the deadline date entered by the user is supposed to be GMT + 7 
    # but the server will think that it is GMT + 0 
    # we have to adjust it -> The info of the offset is in the 
    # school#timezone 
    @deadline_date = params[:project][:deadline_datetime]
    # 02/29/2012
    time_array = @deadline_date.split("/")
    deadline_time = DateTime.civil(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i, 
              DEFAULT_DEADLINE_HOUR, DEFAULT_DEADLINE_MINUTE, 0, 
              # adjust to Jakarta Time +7 -> GMT + 7, out of 24 hours 
              Rational(+7,24) )
              
    @project.deadline_datetime = deadline_time.getutc # server time is UTC 
    # @project.deadline_date = deadline_time.getutc.to_date  # server time is UTC, again.. 
    
    
    @project =  Project.create_project_by_project_creator( current_user , @project) 
 
    @project.create_project_submissions
    
    redirect_to new_course_project_path(@course.id)
  end
  
  
=begin
  Teacher's perspective
  1. Select project
  2. Select submission 
=end
  def select_project_for_grading
    # ensure_role(:teacher)
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    # current_user is teacher 
    @projects = current_user.all_active_projects
    
    add_breadcrumb "Select Project", "select_project_for_grading_url"
  end


  def past_projects
    @projects = current_user.all_passive_projects
    add_breadcrumb "Select Project", "past_projects_url"
  end
  
  def close_project
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @project = Project.find_by_id( params[:entry_id])
    
    if @project.nil? or not @project.created_by?(current_user)
      redirect_to root_url 
      return 
    end
    
    @project.deactivate
  end
  
  def recover_project
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @project = Project.find_by_id( params[:entry_id])
    
    if @project.nil? or not @project.created_by?(current_user)
      redirect_to root_url 
      return 
    end
    
    @project.re_activate
  end
  
  protected
  
  def extract_deadline_time( params_deadline_datetime)
    @deadline_date = params_deadline_datetime
    # 02/29/2012
    time_array = @deadline_date.split("/")
    deadline_time = DateTime.civil(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i, 
              DEFAULT_DEADLINE_HOUR, DEFAULT_DEADLINE_MINUTE, 0, 
              # adjust to Jakarta Time +7 -> GMT + 7, out of 24 hours 
              Rational(+7,24) )
              
  end
  
  
  
  

end
