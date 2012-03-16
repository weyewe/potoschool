class GroupsController < ApplicationController
  def select_subject_for_group
    add_breadcrumb "Select Subject", "select_subject_for_group_url"
    @teacher = current_user
    @subjects = @teacher.all_subjects_taught
  end
  
  def select_course_for_group
    #current user is a teacher
    @subject = Subject.find_by_id( params[:subject_id])
    @courses = current_user.all_courses_for_subject( @subject )
    
    add_breadcrumb "Select Subject", "select_subject_for_project_url"
    set_breadcrumb_for @subject, 'select_course_for_group_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"
  end
  
  def new
    
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
    @groups =  @course.groups
    @new_group = Group.new


    add_breadcrumb "Select Subject", "select_subject_for_project_url"
    set_breadcrumb_for @subject, 'select_course_for_group_path' + "(#{@subject.id})", 
    "Select Course for #{@subject.name}"
    set_breadcrumb_for @course, 'new_course_group_path' + "(#{@course.id})", 
    "Create Group"


  end
  
  def create
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @course = Course.find_by_id( params[:course_id])
    
    if not current_user.teach_course?(@course)
      redirect_to root_url 
      return 
    end
    
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
    
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @group = Group.find_by_id( params[:group_id])
    @course  = @group.course 
    
    if not current_user.teach_course?(@course)
      redirect_to root_url 
      return
    end
    
    
    @students = @group.students
    
    add_breadcrumb "Select Group", "select_group_for_group_leader_url"
    set_breadcrumb_for @group, 'select_group_leader_path' + "(#{@group.id})", 
                "Select Group Leader:  #{@group.name}"
  end
  
  
  def execute_select_group_leader
   
    
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @group_id = params[:membership_provider]
    @group = Group.find_by_id(@group_id)
    @course = @group.course 
    
    if not current_user.teach_course?(@course)
      redirect_to root_url 
      return
    end
    
    
    
    @user_id = params[:membership_consumer]
    @decision = params[:membership_decision].to_i
    
    
    group_leader = @group.update_leader(   @user_id, @decision )
        # 
        # if params[:action_to_the_student].to_i  == ADD_GROUP_LEADER
        #   @new_group_leader = User.find_by_id(  params[:user_id] )
        #   @old_group_leader = @group.group_leader 
        #   @group.add_group_leader( @new_group_leader ) 
        # elsif params[:action_to_the_student].to_i  == REMOVE_GROUP_LEADER
        #   @old_group_leader = User.find_by_id( params[:user_id] )
        #   @group.remove_group_leader( @old_group_leader )
        # end
    
    
    
    respond_to do |format|
      format.html {  redirect_to select_group_leader_path(@group) }
      format.js
    end
    
  end
end
