class CourseTeachingAssignmentsController < ApplicationController
  def new
    @course = Course.find_by_id( params[:course_id] )
    @subject  = @course.subject
    @teachers = @subject.school.teachers
    
    add_breadcrumb "Pick the subject", 'pick_subject_for_course_teaching_assignment_path'
    set_breadcrumb_for @subject, 'new_course_teaching_assignment_path' + "(#{@subject.id})", 
              'Pick the course' 
              
    set_breadcrumb_for @course, 'new_course_course_teaching_assignment_path' + "(#{@course.id})", 
              'Assign Teacher'
    
    
    
  end
  
  
end
