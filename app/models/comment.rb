class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]
  
  validates_presence_of :body
  validates_presence_of :user
  
  has_one :positional_comment
  
  
  
  # NOTE: install the acts_as_votable plugin if you 
  # want user to vote on the quality of comments.
  #acts_as_voteable
  
  # NOTE: Comments belong to a user
  belongs_to :user
  
  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    c = self.new
    c.commentable_id = obj.id 
    c.commentable_type = obj.class.name 
    c.body = comment 
    c.user_id = user_id
    c
  end
  
  #helper method to check if a comment has children
  def has_children?
    self.children.size > 0 
  end
  
  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for 
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id 
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
  
  
=begin
  Additional for positional_comment
=end

  
  
  def create_comment_position( x_start, y_start, x_end, y_end , picture)
    comment_position = PositionalComment.create(:comment_id => self.id, 
      :x_start => x_start, 
      :y_start => y_start,
      :x_end => x_end,
      :y_end => y_end,
      :picture_id => picture.id
    )
    
    # self.delay.send_feedback_notification_email
    
    return comment_position
  end
  
  def commented_object 
    eval("#{self.commentable_type}.find(#{self.commentable_id})")
  end
  
  
  def self.new_user_activity_for_comment_reply( event_type, author, subject, secondary_subject )
    UserActivity.create_new_entry(event_type , 
                        author , 
                        subject , 
                        secondary_subject  )
  end
  
  
  
  protected
  
  def send_feedback_notification_email
    @root_comment = self
    @picture = @root_comment.commented_object 
    @filtered_collaborators_id_list = @picture.project.get_all_collaborators_except( @root_comment.user )   
    
    @filtered_collaborators_id_list.each do |user_id| 
      ProjectMailer.feedback_create_notification( @root_comment, user_id ).deliver
    end
          
    
  end
=begin
a = Comment.last 
a.commented_object.root_comments.first
UserActivity.where(:event_type => EVENT_TYPE[:create_comment]).each do |user_activity| 
  picture = user_activity.extract_object :subject 
  first_root_comment = picture.root_comments.first
  user_activity.secondary_subject_type = user_activity.subject_type 
  user_activity.secondary_subject_id = user_activity.subject_id 
  user_activity.subject_type = first_root_comment.class.to_s
  user_activity.subject_id = first_root_comment.id 
  user_activity.save 
end
=end
 
  
  
end
