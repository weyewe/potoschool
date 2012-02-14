class Picture < ActiveRecord::Base
  belongs_to :project_submission
  
  # so that we can call @picture.revisions
  # and @revision.original_picture
  has_many :revisions, :class_name => "Revision"
  belongs_to :original_picture, :class_name => "Revision",
    :foreign_key => "original_picture_id"
    
    
  acts_as_commentable
  
end
