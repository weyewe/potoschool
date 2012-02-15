class SubjectsController < ApplicationController
  before_filter :ensure_has_school_admin_role
  
  def index
    add_breadcrumb "Pick the subject", 'subjects_path'
  end
  
  def new
    @new_subject  = Subject.new 
  end
  
  def new_subject_teaching_assignment
    @school = current_user.get_managed_school
    @subjects = @school.subjects
    @teachers = @school.teachers
    add_breadcrumb "Pick the subject", 'new_subject_teaching_assignment'
  end
  
  def create
  end
  
end
