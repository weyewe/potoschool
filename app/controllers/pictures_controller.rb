class PicturesController < ApplicationController
  def new
    
    @project_submission = ProjectSubmission.find_by_id( params[:project_submission_id] )
    @project = @project_submission.project
    @pictures = @project_submission.pictures 
    @new_picture = Picture.new  
    
    add_breadcrumb "Select Project", "project_submissions_url"
    set_breadcrumb_for @subject, 'new_project_submission_picture_path' + "(#{@project_submission.id})", 
                "Upload results for project: #{@project.title}"
  end
  
  
  def create
    
    @project_submission = ProjectSubmission.find_by_id(params[:project_submission_id])
    
    if not params[:transloadit].nil?
      Picture.extract_uploads( 
        params[:transloadit][:results][":original".to_sym],
        params[:transloadit][:results][:resize_index], 
        params[:transloadit][:results][:resize_show], 
        params[:transloadit][:results][:resize_revision], 
        params, params[:transloadit][:uploads] )
    end 
      
    redirect_to new_project_submission_picture_path(@project_submission)
  end
  
  
end
