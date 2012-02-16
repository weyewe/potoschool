class SubjectRegistrationsController < ApplicationController
  def pick_subject_for_student_registrations
    #current user is assumed to be school_admin role 
    add_breadcrumb "Select Subject", "pick_subject_for_student_registrations_path"
    @subjects = current_user.get_managed_school.subjects 
  end
  
  def new
    @subject = Subject.find_by_id( params[:subject_id]) 
    @students = current_user.get_managed_school.students 
    add_breadcrumb "Select Subject", "pick_subject_for_student_registrations_path"
    set_breadcrumb_for @subject, 'new_subject_subject_registration_path' + "(#{@subject.id})", 
              'Assign Student for ' + "#{@subject.name}"
  end
end
