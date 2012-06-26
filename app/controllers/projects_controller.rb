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
    @school = current_user.get_enrolled_school 
    
    @project.update_attributes( params[:project] )
    @project.deadline_datetime = extract_date_time( params[:project][:deadline_datetime],
                params[:deadline_hour], params[:deadline_minute],  @school).getutc
    @project.starting_datetime = extract_date_time( params[:project][:starting_datetime],
                params[:starting_hour], params[:starting_minute],  @school).getutc
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
    
    
    @school = current_user.get_enrolled_school 
    
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
    
    # our new approach -> server will only store the UTS
    # @deadline_date = params[:project][:deadline_datetime]
    # 02/29/2012
    # time_array = @deadline_date.split("/")
    # deadline_time = DateTime.civil(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i, 
    #               DEFAULT_DEADLINE_HOUR, DEFAULT_DEADLINE_MINUTE, 0, 
    #               # adjust to Jakarta Time +7 -> GMT + 7, out of 24 hours 
    #               Rational(+7,24) )
    deadline_time =  extract_date_time( params[:project][:deadline_datetime] , params[:deadline_hour], 
                params[:deadline_minute], @school )
              
    starting_time =   extract_date_time( params[:project][:starting_datetime] , params[:starting_hour], 
                  params[:starting_minute], @school )
              
              # DateTime.new(2012,8,8, deadline_hour, deadline_minute, 0).in_time_zone("Jakarta")
              # DateTime.new(2012,8,8, 12, 30, 0).in_time_zone(@school.get_time_zone)
    
    @project.deadline_datetime = deadline_time.getutc # server time is UTC 
    # @project.deadline_date = deadline_time.getutc.to_date  # server time is UTC, again.. 
    @project.starting_datetime = starting_time.getutc
    
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
  
# publish grade projects

  def select_project_to_publish_grade
    @projects = current_user.all_projects.order("deadline_datetime ASC")
    add_breadcrumb "Select Project", "select_project_to_publish_grade_url"
  end
  
  def execute_publish_grade
    
    
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @project = Project.find_by_id( params[:entry_id])
    
    if @project.nil? or not @project.created_by?(current_user)
      redirect_to root_url 
      return 
    end
    
    @project.activate_publish_grade
    
    
  end
  
  
=begin
  School admin perspective 
=end

  def select_active_project_for_admin
    # ensure_role(:teacher)
    if not current_user.has_role?(:school_admin)
      redirect_to root_url
      return
    end
    # current_user is teacher 
    @school = current_user.get_managed_school
    @teachers = @school.teachers
    
    add_breadcrumb "Select Project", "select_active_project_for_admin_url"
  end


=begin
  Data Analysis
=end

  def view_submission_rate
    @project = Project.find_by_id params[:project_id]
    
    add_breadcrumb "Select Project", "select_active_project_for_admin_url"
    set_breadcrumb_for @project, 'view_submission_rate_url' + "(#{@project.id})", 
                "Submission Data"
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
  
  def extract_date_time( params_deadline_datetime, params_hour , params_minute , school)
    if params_deadline_datetime.nil? or params_deadline_datetime.length ==0 
      return DateTime.now.in_time_zone(school.get_time_zone)
    end
    
    time_array = params_deadline_datetime.split("/")
  
    hour = 0 
    if params_hour.nil? || params_hour.length ==0  
      hour = 0
    else
      hour = params_hour.to_i
    end
    
    minute = 0 
    if params_minute.nil? || params_minute.length ==0  
      minute = 0
    else
      minute = params_minute.to_i
    end        
              
              
              
    DateTime.new(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i,
                  hour, minute, 0,
                  Rational(school.get_utc_offset , 24) )
              
              
  end
  
  
  
  

end
