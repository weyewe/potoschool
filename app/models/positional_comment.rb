class PositionalComment < ActiveRecord::Base
  belongs_to :comment
  belongs_to :picture
  
  def self.create_with_comment( params, user, picture)
    @root_comment = Comment.build_from(picture, user.id, params[:comment_value])
    @root_comment.save
    
    @root_comment.create_comment_position( params[:x1], params[:y1], params[:x2], params[:y2] ,  picture)
  end
  
  def self.new_user_activity_for_new_comment( event_type, commenter, subject, secondary_subject )
    UserActivity.create_new_entry(event_type , 
                        commenter , 
                        subject , 
                        secondary_subject  )
  end
  
  
  def marker_x_value
    (self.x_start + self.x_end)/2 #- POSITIONAL_COMMENT_MARKER_WIDTH/2
  end
  
  def marker_y_value
    (self.y_start + self.y_end)/ 2 #- POSITIONAL_COMMENT_MARKER_WIDTH/2
  end
  
  
  
end
