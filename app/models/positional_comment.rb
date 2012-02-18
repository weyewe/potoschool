class PositionalComment < ActiveRecord::Base
  belongs_to :comment
  belongs_to :picture
  
  def self.create_with_comment( params, user, picture)
    @root_comment = Comment.build_from(picture, user.id, params[:comment_value])
    @root_comment.save
    
    @root_comment.create_comment_position( params[:x1], params[:y1], params[:x2], params[:y2] ,  picture)
    # return positional_comment
  end
   #  
   # def add_positional_comment
   #   @picture = Picture.find(params[:picture_id])
   #   @user_who_commented = current_user
   #   @root_comment = Comment.build_from( @picture, @user_who_commented.id, params[:comment_value] )
   #   @root_comment.save
   #   
   #   @root_comment.create_comment_position( params[:x1], params[:y1], params[:x2], params[:y2] ,  @picture)
   #   
   #   
   #   respond_to do |format|
   #     format.html {  redirect_to project_picture_url( @picture.project, @picture)}
   #     format.js
   #   end
   #   
   #   
   #   
   # end
   # 
   # 
   # 
   # def create_comment_position( x_start, y_start, x_end, y_end , picture)
   #   comment_position = CommentPosition.create(:comment_id => self.id, 
   #     :x_start => x_start, 
   #     :y_start => y_start,
   #     :x_end => x_end,
   #     :y_end => y_end,
   #     :picture_id => picture.id
   #   )
   #   
   #   # self.delay.send_feedback_notification_email
   #   
   #   return comment_position
   # end
   # 
  
  
end
