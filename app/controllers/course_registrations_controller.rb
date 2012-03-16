class CourseRegistrationsController < ApplicationController
  
  def select_subject_for_course_registration
    add_breadcrumb "Pick the subject", 'select_subject_for_course_registration_path'
    #current user is assumed to be admin
    @subjects = current_user.get_managed_school.all_active_subjects 
    
    # set_breadcrumb_for @subject, 'new_course_teaching_assignment_path' + "(#{@subject.id})", 
    #             'Pick the course'
  end 
  
  
  def select_course_for_course_registration
    @subject = Subject.find_by_id( params[:subject_id] )
    @courses = @subject.courses
    add_breadcrumb "Pick Subject", 'select_subject_for_course_registration_path'
    set_breadcrumb_for @subject, 'select_course_for_course_registration_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"
  end
  
  
  def new 
    if not current_user.has_role?(:school_admin)
      redirect_to root_url
      return 
    end
    
    @course = Course.find_by_id( params[:course_id] )
    @subject  = @course.subject
    
    @students = @subject.school.students
    
    
    add_breadcrumb "Pick the subject", 'select_subject_for_course_registration_path'
    set_breadcrumb_for @subject, 'select_course_for_course_registration_path' + "(#{@subject.id})", 
                "Select Course for #{@subject.name}"
    set_breadcrumb_for @subject, 'new_course_course_registration_path' + "(#{@course.id})", 
                "Assign teacher for #{@course.name}"
                
                
                
  end
  
  def create
    
    if not current_user.has_role?(:school_admin)
      redirect_to root_url
      return 
    end
    

    @course_id = params[:membership_provider]
    @user_id = params[:membership_consumer]
    @decision = params[:membership_decision].to_i

    @student = User.find_by_id @user_id
    @course = Course.find_by_id @course_id
    
    if not current_user.manage_school?( @course.subject.school )
      redirect_to root_url
      return 
    end
    
    
    @course_registration = CourseRegistration.assignment_update( @course_id, @user_id, @decision )


    respond_to do |format|
      format.html {  redirect_to new_subject_subject_teaching_assignment_path(@subject)}
      format.js
    end
  end
  
end
