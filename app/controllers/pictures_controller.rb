class PicturesController < ApplicationController
  def new
    
    @project_submission = ProjectSubmission.find_by_id( params[:project_submission_id] )
    
    if @project_submission.user_id != current_user.id
      redirect_to root_url
      return
    end
    
    @project = @project_submission.project
    @pictures = @project_submission.original_pictures
    @new_picture = Picture.new  
    
    add_breadcrumb "Select Project", "project_submissions_url"
    set_breadcrumb_for @subject, 'new_project_submission_picture_path' + "(#{@project_submission.id})", 
                "Upload results for project: #{@project.title}"
  end
  
  
  def create
    
    @project_submission = ProjectSubmission.find_by_id(params[:project_submission_id])
    if @project_submission.user_id != current_user.id
      redirect_to root_url
      return
    end
    
    
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
  
  
  def delete_original_image
    @picture = Picture.find_by_id params[:picture_id]
    @project = @picture.project_submission.project 
    @project_submission = @picture.project_submission 
    
    if @picture.is_uploaded_by?( current_user ) 
      # delete code 
      @picture.set_deleted
    end
    
    redirect_to new_project_submission_picture_url(@project_submission) 
  end
  
  def delete_image_from_show
    @picture = Picture.find_by_id params[:picture_id]
    @project = @picture.project_submission.project 
    @project_submission = @picture.project_submission 
    
    if @picture.is_uploaded_by?( current_user ) 
      # delete code 
      @picture.set_deleted
    end
    
    if @picture.is_original? 
      redirect_to new_project_submission_picture_url(@project_submission) 
      return
    else
      # get last approved, show it 
      last_approved_revision = @picture.last_approved_revision
      redirect_to project_submission_picture_url( last_approved_revision.project_submission, 
        last_approved_revision )
    end
    
    
  end
  
  def show
    @project_submission = ProjectSubmission.find_by_id(params[:project_submission_id])
    if @project_submission.user_id != current_user.id
      redirect_to root_url
      return
    end
    
    @project = @project_submission.project 
    @school = current_user.get_enrolled_school
    
    @picture = Picture.find_by_id( params[:id] )
    @original_picture = @picture.original_picture
    @all_revisions = @original_picture.revisions.where(:is_deleted => false ).order("created_at DESC")
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
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    # ensure_role(:teacher)
    @picture = Picture.find_by_id( params[:picture_id] )
    @project_submission = @picture.project_submission
    @project = @project_submission.project
    @user = @project_submission.user 
    
    if @project.nil? or not @project.created_by?(current_user)
      redirect_to root_url 
      return 
    end
    
    @root_comments = @picture.root_comments.order("created_at ASC")
    
    @original_picture = @picture.original_picture
    @all_revisions = @original_picture.revisions.where(:is_deleted => false). order("created_at DESC")
    
    
    add_breadcrumb "Select Project", "select_project_for_grading_url"
    set_breadcrumb_for @subject, 'select_project_submission_for_grading_path' + "(#{@project.id})", 
                "Select Student Submission"
                
    set_breadcrumb_for @subject, 'show_submission_pictures_for_grading_path' + "(#{@project_submission.id})", 
              "Results"
    set_breadcrumb_for @subject, 'grade_project_submission_picture_path' + "(#{@picture.id})", 
              "Details"
              
              
  end


  # the method name might be misleading
  # there is no grade involved. Just a notification whether a certain submission is rejected or 
  # approved. Used during the tutorial period: student upload image, 
  # asks for teacher's feedback, or approval, whether such image is OK 
  def execute_grading
    
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    # ensure_role(:teacher) # ensuring role is not enough. further information is needed , like project ownership
    # if we are only protecting in the role level, what if there is a corrupted user? 
    # we are doomed 
    @picture = Picture.find_by_id(params[:picture_id])
    @original_picture = @picture.original_picture
    @project_submission = @picture.project_submission
    @project = @project_submission.project 
    
    if @project.nil? or not @project.created_by?(current_user)
      redirect_to root_url 
      return 
    end
 
    
    if params[:picture][:is_approved].to_i == ACCEPT_SUBMISSION
      @picture.is_approved = true 
      # @picture.score = params[:picture][:score]
      @picture.save
      @original_picture.approved_revision_id = @picture.id 
      @original_picture.save 
      @project_submission.update_score 
      # @project_submission.update_total_project_score  
      # total project score only be generated when the project is closed by the teacher. 
      # the engine will calculate the final value -> sum n submissions score / n
      
    elsif params[:picture][:is_approved].to_i == REJECT_SUBMISSION
      @picture.is_approved = false
      # @picture.score = params[:picture][:score]
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
  
  def execute_grading_score
    # sleep 3 
    @picture=  Picture.find_by_id params[:picture_id]
    @project= @picture.project_submission.project 
    
    if ( not current_user.has_role?(:teacher) ) or
        ( not @project.created_by?(current_user) )
        redirect_to root_url 
        return 
    end
    
   
    
    @picture.set_score( params[:picture][:score].to_i, current_user )
    

    respond_to do |format|
      format.html {  redirect_to root_url  }
      format.js
    end
    
  end
  
  def gallery_mode_grading
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @project = Project.find_by_id params[:project_id]
    
    if @project.nil? or not @project.created_by?(current_user)
      redirect_to root_url 
      return
    end
    
    @project_submissions = @project.project_submissions.
                              includes(:pictures).order("created_at DESC")
                              
    
    
    add_breadcrumb "Select Project", "select_project_for_grading_url"
    set_breadcrumb_for @project, 'select_project_submission_for_grading_path' + "(#{@project.id})", 
                "Select Student Submission"
    set_breadcrumb_for @project, 'gallery_mode_grading_path' + "(#{@project.id})", 
                "Gallery Mode"
  end
  
  
  def gallery_picture_grading
    if not current_user.has_role?(:teacher)
      redirect_to root_url
      return
    end
    
    @project = Project.find_by_id params[:project_id]
    @picture = Picture.find_by_id params[:picture_id]
    
    if @project.nil? or not @project.created_by?(current_user)
      redirect_to root_url 
      return 
    end
    
    @root_comments = @picture.root_comments.order("created_at ASC")
    
    @original_picture = @picture.original_picture
    @all_revisions = @original_picture.revisions.where(:is_deleted => false).order("created_at DESC")
    
    @project_submission = @picture.project_submission
    @user = @project_submission.user 
    
    
    add_breadcrumb "Select Project", "select_project_for_grading_url"
    set_breadcrumb_for @project, 'select_project_submission_for_grading_path' + "(#{@project.id})", 
                "Select Student Submission"
    set_breadcrumb_for @project, 'gallery_mode_grading_path' + "(#{@project.id})", 
                "Gallery Mode"
    set_breadcrumb_for @project, 'gallery_picture_grading_path' + "(#{@project.id}, #{@picture.id})", 
                "Grading"
                
  end
  
=begin
  For the school admin
=end
  
  def gallery_mode_active_project
    if not current_user.has_role?(:school_admin)
      redirect_to root_url
      return
    end
    
    @project = Project.find_by_id params[:project_id]
    @teacher = User.find_by_id params[:teacher_id]
    @school = current_user.get_managed_school
    
    if (@project.nil? ) or ( not @project.created_by?(@teacher) )  or 
          (not @school.has_enrollment?( @teacher ) )  or 
          ( not @teacher.has_role?(:teacher))
      redirect_to root_url 
      return 
    end
    
    @project_submissions = @project.project_submissions.
                              includes(:pictures).order("created_at DESC")
                              
    
    
    add_breadcrumb "Select Project", "select_active_project_for_admin_url"
    set_breadcrumb_for @project, 'gallery_mode_active_project_path' + "(  #{@teacher.id} , #{@project.id})", 
                "Gallery View"
   
  end
  
  
end
