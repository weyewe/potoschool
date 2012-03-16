class SubjectRegistrationsController < ApplicationController
  def pick_subject_for_student_registrations
    #current user is assumed to be school_admin role 
    add_breadcrumb "Select Subject", "pick_subject_for_student_registrations_path"
    @subjects = current_user.get_managed_school.all_active_subjects 
  end
  
  def new
   if not current_user.has_role?(:school_admin)
      redirect_to root_url
      return 
    end
    
    
    
    @subject = Subject.find_by_id( params[:subject_id]) 
    @students = current_user.get_managed_school.students 
    add_breadcrumb "Select Subject", "pick_subject_for_student_registrations_path"
    set_breadcrumb_for @subject, 'new_subject_subject_registration_path' + "(#{@subject.id})", 
              'Assign Student for ' + "#{@subject.name}"
  end
  
  
  def create
    if not current_user.has_role?(:school_admin)
      redirect_to root_url
      return 
    end

    @subject_id = params[:membership_provider]
    @subject  = Subject.find_by_id(@subject_id)

    if not current_user.manage_school?( @subject.school )
      redirect_to root_url
      return 
    end


    @user_id = params[:membership_consumer]
    @decision = params[:membership_decision].to_i

    @student = User.find_by_id @user_id

    @subject_registration = SubjectRegistration.assignment_update( @subject_id, @user_id, @decision )


    respond_to do |format|
      format.html {  redirect_to new_subject_subject_teaching_assignment_path(@subject)}
      format.js
    end
  end
end
