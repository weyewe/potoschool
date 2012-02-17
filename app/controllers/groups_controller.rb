class GroupsController < ApplicationController
  def select_subject_for_group
    add_breadcrumb "Select Subject", "select_subject_for_group_url"
    @teacher = current_user
    @subjects = @teacher.all_subjects_taught
  end
  
  def select_course_for_group
    @subject = Subject.find_by_id( params[:subject_id])
    @courses = @subject.courses 
    
    add_breadcrumb "Select Subject", "select_subject_for_project_url"
    set_breadcrumb_for @subject, 'select_course_for_group_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"
  end
  
  def new
    
     @course = Course.find_by_id( params[:course_id])
      @subject = @course.subject
      @groups =  @course.groups
      @new_group = Group.new


      add_breadcrumb "Select Subject", "select_subject_for_project_url"
      set_breadcrumb_for @subject, 'select_course_for_group_path' + "(#{@subject.id})", 
                  "Select Course for #{@subject.name}"
      set_breadcrumb_for @course, 'new_course_group_path' + "(#{@course.id})", 
                  "Create Group"
                  
                  
  end
  
  def create
    @course = Course.find_by_id(params[:course_id])
    @group = Group.new(params[:group])
    @group.course_id = @course.id
    
    @group.save
    
    redirect_to new_course_group_url(@course)
  end
  
 

  def select_group_for_group_leader
    #current user is teacher
    add_breadcrumb "Select Group", "select_group_for_group_leader_url"
    
    # @courses = current_user.all_courses_taught
    @courses = current_user.all_courses_and_groups_taught
    
  end
  
  
  
  def select_group_leader
    @group = Group.find_by_id( params[:group_id])
    @students = @group.students
    
    add_breadcrumb "Select Group", "select_group_for_group_leader_url"
    set_breadcrumb_for @group, 'select_group_leader_path' + "(#{@group.id})", 
                "Select Group Leader"
  end
end
