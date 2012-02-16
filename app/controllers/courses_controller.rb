class CoursesController < ApplicationController
  def new 
    
    @subject = Subject.find_by_id( params[:subject_id] )
    @new_course = Course.new 
    
    add_breadcrumb "Pick the subject", 'subjects_path'
    set_breadcrumb_for @subject, 'new_subject_course_path' + "(#{@subject.id})", 
              'Create new course for ' + "#{@subject.name}"
  end
  
  
  def pick_subject_for_course_teaching_assignment
    add_breadcrumb "Pick the subject", 'pick_subject_for_course_teaching_assignment_path'
    @subjects = current_user.get_managed_school.subjects 
  end
  
  def new_course_teaching_assignment
    @subject = Subject.find_by_id( params[:subject_id] )
    @courses = @subject.courses
    
    add_breadcrumb "Pick the subject", 'pick_subject_for_course_teaching_assignment_path'
    set_breadcrumb_for @subject, 'new_course_teaching_assignment_path' + "(#{@subject.id})", 
              'Pick the course' 
    
  end

end
