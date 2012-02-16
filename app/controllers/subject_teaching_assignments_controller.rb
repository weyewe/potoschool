class SubjectTeachingAssignmentsController < ApplicationController
  def new
    @subject = Subject.find_by_id( params[:subject_id] )
    @teachers = @subject.school.teachers
    
    add_breadcrumb "Pick the subject", 'new_subject_teaching_assignment_path'
    set_breadcrumb_for @subject, 'new_subject_subject_teaching_assignment_path' + "(#{@subject.id})", 
              'Create new course for ' + "#{@subject.name}"
             
  end
  
  def create
  end
  

end
