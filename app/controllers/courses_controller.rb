class CoursesController < ApplicationController
  def new 
    
    @subject = Subject.find_by_id( params[:subject_id] )
    @new_course = Course.new 
    
    add_breadcrumb "Pick the subject", 'subjects_path'
    set_breadcrumb_for @subject
  end
  
  private
  def set_breadcrumb_for subject
    add_breadcrumb "Create new course for #{subject.name}", "new_subject_course_path(#{subject.id})"
  end
end
