class CommentsController < ApplicationController
  def create_first_child_comment
    @root_comment = Comment.find_by_id(params[:root_comment_id])
    @picture = Picture.find_by_id( params[:picture_id])

    
    @comment = Comment.build_from( @picture, current_user.id, params[:comment][:body] )
    @comment.save
    @comment.move_to_child_of(@root_comment)
    
    
    respond_to do |format|
      format.html {  redirect_to project_submission_picture_path(@picture ,@picture) }
      format.js
    end
    
    
    
  end
end
