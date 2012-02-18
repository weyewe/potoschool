class PicturesController < ApplicationController
  def new
    
    @project_submission = ProjectSubmission.find_by_id( params[:project_submission_id] )
    @project = @project_submission.project
    @pictures = @project_submission.original_pictures
    @new_picture = Picture.new  
    
    add_breadcrumb "Select Project", "project_submissions_url"
    set_breadcrumb_for @subject, 'new_project_submission_picture_path' + "(#{@project_submission.id})", 
                "Upload results for project: #{@project.title}"
  end
  
  
  def create
    
    @project_submission = ProjectSubmission.find_by_id(params[:project_submission_id])
    new_picture = ""
    if not params[:transloadit].nil?
      new_picture = Picture.extract_uploads( 
        params[:transloadit][:results][":original".to_sym],
        params[:transloadit][:results][:resize_index], 
        params[:transloadit][:results][:resize_show], 
        params[:transloadit][:results][:resize_revision], 
        params, params[:transloadit][:uploads] )
    end 
      
    if params[:original_picture_id].nil?
      # it is from new picture page
      redirect_to new_project_submission_picture_path(@project_submission)
    else 
      # it is to create revision
      redirect_to project_submission_picture_path(@project_submission,new_picture)
    end
  end
  
  
  
  def show
    @project_submission = ProjectSubmission.find_by_id(params[:project_submission_id])
    @picture = Picture.find_by_id( params[:id] )
    @original_picture = @picture.original_picture
    @all_revisions = @original_picture.revisions
    
    add_breadcrumb "Select Project", "project_submissions_url"
    set_breadcrumb_for @subject, 'new_project_submission_picture_path' + "(#{@project_submission.id})", 
                "Upload result"
    set_breadcrumb_for @subject, 'project_submission_picture_path' + "(#{@project_submission.id}, #{@picture.id})", 
                "Give Feedback"
  end
  
  
  
  
  
end
