class ProjectSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  has_many :pictures 
  
  # project submission is the album (per person)
  # each submission can contain several pictures, with several revisions for per picture 
  
  
  def approved?
    self.is_approved == true 
  end
    
    
  # can be commented 
  # acts_as_commentable
  
  
end
