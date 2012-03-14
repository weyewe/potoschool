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
    if not params[:transloadit].nil? and not params[:picture_filetype].nil?
      if params[:picture_filetype].to_i ==  PICTURE_FILETYPE[:image]  
        puts "Strangely, we are inside the image\n"*10
        new_picture = Picture.extract_uploads( 
          params[:transloadit][:results][":original".to_sym],
          params[:transloadit][:results][:resize_index], 
          params[:transloadit][:results][:resize_show], 
          params[:transloadit][:results][:resize_revision], 
          params, params[:transloadit][:uploads] )
      elsif params[:picture_filetype].to_i !=  PICTURE_FILETYPE[:image]  
        puts "Yeah baby, we are inside the scribd\n"*10
        new_picture = Picture.extract_scribd_upload( 
          params[:transloadit][:results][":original".to_sym],
          params, params[:transloadit][:uploads] )
      end
      
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
    @all_revisions = @original_picture.revisions.order("created_at DESC")
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
    @all_revisions = @original_picture.revisions.order("created_at DESC")
    
    
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
    @original_picture = @picture.original_picture
    @project_submission = @picture.project_submission
 
    
    if params[:picture][:is_approved].to_i == ACCEPT_SUBMISSION
      @picture.is_approved = true 
      @picture.score = params[:picture][:score]
      @picture.save
      @original_picture.approved_revision_id = @picture.id 
      @original_picture.save 
      @project_submission.update_score 
      # @project_submission.update_total_project_score  
      # total project score only be generated when the project is closed by the teacher. 
      # the engine will calculate the final value -> sum n submissions score / n
      
    elsif params[:picture][:is_approved].to_i == REJECT_SUBMISSION
      @picture.is_approved = false
      @picture.score = params[:picture][:score]
      @picture.save
    else
    end
    
    Picture.new_user_activity_for_grading(
      EVENT_TYPE[:grade_picture],
      current_user ,  #this is the teacher
      @picture,  #picture being graded
      @picture.project_submission.project   #the project where that picture belongs to 
    )
    
    
    respond_to do |format|
      format.html {  redirect_to project_submission_picture_path(@picture ,@picture) }
      format.js
    end
  end
  
  
end
