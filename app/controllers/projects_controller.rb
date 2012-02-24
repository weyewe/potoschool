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
    @subject = Subject.find_by_id( params[:subject_id])
    @courses = @subject.courses 
    
    add_breadcrumb "Select Subject", "select_subject_for_project_url"
    set_breadcrumb_for @subject, 'select_course_for_project_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"

    
  end
  
  def new 
    @course = Course.find_by_id( params[:course_id])
    @subject = @course.subject
    @new_project = Project.new
    
    @projects = @course.projects
    
    add_breadcrumb "Select Subject", "select_subject_for_project_url"
    set_breadcrumb_for @subject, 'select_course_for_project_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"
    set_breadcrumb_for @course, 'new_course_project_path' + "(#{@course.id})", 
                "Create Project"       
  end
  
  
  def create
    @course = Course.find_by_id( params[:course_id])
    @project = Project.new( params[:project])
    @project.course_id = @course.id
    if params[:project][:is_group_project].to_i == TRUE_CHECK
      @project.is_group_project = true 
    else
      @project.is_group_project = false 
    end
    
    @project.save
    @project.create_project_submissions
    
    redirect_to new_course_project_path(@course.id)
  end
  
  
=begin
  Teacher's perspective
  1. Select project
  2. Select submission 
=end
  def select_project_for_grading
    @projects = current_user.all_active_projects
    
    add_breadcrumb "Select Project", "select_project_for_grading_url"
  end
  
  
    # 
    # def project_submissions_display
    #   @projects = current_user.all_active_projects
    # end
  
  

end
