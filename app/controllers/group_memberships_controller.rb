class GroupMembershipsController < ApplicationController
  def select_subject_for_group_membership
    add_breadcrumb "Select Subject", "select_subject_for_group_membership_path"
    @teacher = current_user
    @subjects = @teacher.all_subjects_taught
  end
  
  def select_course_for_group_membership
    @subject = Subject.find_by_id( params[:subject_id])
    @courses = @subject.courses 
    
    add_breadcrumb "Select Subject", "select_subject_for_group_membership_path"
    set_breadcrumb_for @subject, 'select_course_for_group_membership_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"
  end
  
  def select_group
    
    @course = Course.find_by_id(params[:course_id])
    @groups = @course.groups
    @subject = @course.subject
    
    add_breadcrumb "Select Subject", "select_subject_for_group_membership_path"
    set_breadcrumb_for @subject, 'select_course_for_group_membership_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"
    set_breadcrumb_for @subject, 'select_group_path' + "(#{@course.id})", 
                "Select Group for #{@course.name}"
                
  end
  
  def new
    @group = Group.find_by_id( params[:group_id])
    @course = @group.course
    @subject = @course.subject
    @course_students = @course.students
    
    add_breadcrumb "Select Subject", "select_subject_for_group_membership_path"
    set_breadcrumb_for @subject, 'select_course_for_group_membership_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"
    set_breadcrumb_for @subject, 'select_group_path' + "(#{@course.id})", 
                "Select Group for #{@course.name}"
    set_breadcrumb_for @group, 'new_group_group_membership_path' + "(#{@group.id})", 
                "Assign Student for #{@group.name}"
    
    
  end
  
  
  def create
    @group_id = params[:membership_provider]
    @group = Group.find_by_id(@group_id)
    @user_id = params[:membership_consumer]
    @decision = params[:membership_decision].to_i
    
    @group_membership = GroupMembership.membership_update( @group_id, @user_id, @decision )
  end
end
