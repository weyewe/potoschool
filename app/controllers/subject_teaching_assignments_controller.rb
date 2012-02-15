class SubjectTeachingAssignmentsController < ApplicationController
  def new
    @subject = Subject.find_by_id( params[:subject_id] )
    @teachers = @subject.school.teachers
    
    add_breadcrumb "Pick the subject", 'new_subject_teaching_assignment_path'
    set_breadcrumb_for @subject
    
  end
  
  def create
  end
  
  private
  def set_breadcrumb_for subject
    add_breadcrumb "Create new course for #{subject.name}", "new_subject_subject_teaching_assignment_path(#{subject.id})"
  end
  
end
