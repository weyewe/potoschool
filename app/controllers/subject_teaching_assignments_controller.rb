class SubjectTeachingAssignmentsController < ApplicationController
  def new
    @subject = Subject.find_by_id( params[:subject_id] )
    @teachers = @subject.school.teachers
    
    add_breadcrumb "Pick the subject", 'new_subject_teaching_assignment_path'
    set_breadcrumb_for @subject, 'new_subject_subject_teaching_assignment_path' + "(#{@subject.id})", 
              'Create new course for ' + "#{@subject.name}"
             
  end
  
  def create
    @subject = Subject.find_by_id( params[:subject_id] )
    
    
    @subject_id = params[:membership_provider]
    @user_id = params[:membership_consumer]
    @decision = params[:membership_decision].to_i
    
    @subject_teaching_assignment = SubjectTeachingAssignment.assignment_update( @subject_id, @user_id, @decision )
    
    
    @teacher= User.find_by_id( @user_id )
    
    respond_to do |format|
      format.html {  redirect_to new_subject_subject_teaching_assignment_path(@subject)}
      format.js
    end
  end
  

end
