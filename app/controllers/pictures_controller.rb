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
    @root_comments = @picture.root_comments.order("created_at ASC")
    
    add_breadcrumb "Select Project", "project_submissions_url"
    set_breadcrumb_for @subject, 'new_project_submission_picture_path' + "(#{@project_submission.id})", 
                "Upload result"
    set_breadcrumb_for @subject, 'project_submission_picture_path' + "(#{@project_submission.id}, #{@picture.id})", 
                "Give Feedback"
  end
  
  
  
=begin
  TEACHER's VIEW
=end
  def grade_project_submission_picture
    @picture = Picture.find_by_id( params[:picture_id] )
    @project_submission = @picture.project_submission
    @project = @project_submission.project
    @root_comments = @picture.root_comments.order("created_at ASC")
    
    @original_picture = @picture.original_picture
    @all_revisions = @original_picture.revisions
    
    
    add_breadcrumb "Select Project", "select_project_for_grading_url"
    set_breadcrumb_for @subject, 'select_project_submission_for_grading_path' + "(#{@project.id})", 
                "Select Student Submission"
                
    set_breadcrumb_for @subject, 'show_submission_pictures_for_grading_path' + "(#{@project_submission.id})", 
              "Results"
    set_breadcrumb_for @subject, 'grade_project_submission_picture_path' + "(#{@picture.id})", 
              "Details"
              
              
  end


  def execute_grading
    @picture = Picture.find_by_id(params[:picture_id])
    puts "hahahaha\n"*10
    puts params[:picture][:is_approved]
    # is_approved
    
    if params[:picture][:is_approved].to_i == ACCEPT_SUBMISSION
      @picture.is_approved = true 
    elsif params[:picture][:is_approved].to_i == REJECT_SUBMISSION
      @picture.is_approved = false
    else
    end
    @picture.save 
    
    
    respond_to do |format|
      format.html {  redirect_to project_submission_picture_path(@picture ,@picture) }
      format.js
    end
  end
  
  
end
