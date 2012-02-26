class CourseTeachingAssignmentsController < ApplicationController
  def new
    @course = Course.find_by_id( params[:course_id] )
    @subject  = @course.subject
    @teachers = @subject.teachers
    
    add_breadcrumb "Pick the subject", 'pick_subject_for_course_teaching_assignment_path'
    set_breadcrumb_for @subject, 'new_course_teaching_assignment_path' + "(#{@subject.id})", 
              'Pick the course' 
              
    set_breadcrumb_for @course, 'new_course_course_teaching_assignment_path' + "(#{@course.id})", 
              'Assign Teacher'
  end
  
  def create
    
    @course_id = params[:membership_provider]
    @user_id = params[:membership_consumer]
    @decision = params[:membership_decision].to_i
    
    @teacher = User.find_by_id @user_id
    
    @course_teaching_assignment = CourseTeachingAssignment.assignment_update( @course_id, @user_id, @decision )
    
    
    respond_to do |format|
      format.html {  redirect_to new_subject_subject_teaching_assignment_path(@subject)}
      format.js
    end
  end
  
  
end
