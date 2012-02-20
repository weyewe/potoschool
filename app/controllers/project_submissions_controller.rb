class ProjectSubmissionsController < ApplicationController
  def index
    # assume that current user is student 
    
    @project_submissions = ProjectSubmission.find(:all, :conditions => {
      :user_id => current_user.id
    })
    
    add_breadcrumb "Select Project", "project_submissions_url"
    
  end
  
  def teacher_display
  end
  
  def select_project_submission_for_grading
    @project = Project.find_by_id( params[:project_id] )
    @project_submissions = ProjectSubmission.eager_load_project_submissions_for(@project)
    
    add_breadcrumb "Select Project", "select_project_for_grading_url"
    set_breadcrumb_for @subject, 'select_project_submission_for_grading_path' + "(#{@project.id})", 
                "Select Student Submission"
  end
  
  def show_submission_pictures_for_grading 
    @project_submission = ProjectSubmission.find_by_id( params[:project_submission_id])
    @project = @project_submission.project 
    @original_pictures = @project_submission.original_pictures #.includes(:positional_comments) 
    
    add_breadcrumb "Select Project", "select_project_for_grading_url"
    set_breadcrumb_for @subject, 'select_project_submission_for_grading_path' + "(#{@project.id})", 
                "Select Student Submission"
                
    set_breadcrumb_for @subject, 'show_submission_pictures_for_grading_path' + "(#{@project_submission.id})", 
              "Results"
  end
  
end
