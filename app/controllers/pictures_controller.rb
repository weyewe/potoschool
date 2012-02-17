class PicturesController < ApplicationController
  def new
    
    @project_submission = ProjectSubmission.find_by_id( params[:project_submission_id] )
    @project = @project_submission.project
    @new_picture = Picture.new  
    
    add_breadcrumb "Select Project", "project_submissions_url"
    set_breadcrumb_for @subject, 'new_project_submission_picture_path' + "(#{@project_submission.id})", 
                "Upload results for project #{@project.title}"
  end
end
