class ProjectSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  has_many :pictures 
  
  # project submission is the album (per person)
  # each submission can contain several pictures, with several revisions for per picture 
  
  
  def approved?
    self.is_approved == true 
  end
  
  def original_pictures
    self.pictures.where(:is_original => true )
  end
  
  def original_pictures_id
    self.pictures.where(:is_original => true ).select(:id).map do |x|
      x.id
    end
  end
    
   
    
  # can be commented 
  # acts_as_commentable
  
  
end
