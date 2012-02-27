class ProjectSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  has_many :pictures 
  
  # project submission is the album (per person)
  # each submission can contain several pictures, with several revisions for per picture 
  
  
  def approved?
    self.is_approved == true 
  end
  
  def approved_picture
    Picture.find_by_id(self.approved_submission_id)
  end
  
  def original_pictures
    self.pictures.where(:is_original => true ).order("created_at ASC")
  end
  
  def original_pictures_id
    self.pictures.where(:is_original => true ).order("created_at ASC").select(:id).map do |x|
      x.id
    end
  end
    
  def first_submission
    picture_submissions = self.original_pictures
    if picture_submissions.count == 0 
      return nil
    else
      return picture_submissions.first
    end
  end
    
  # can be commented 
  # acts_as_commentable
  
  
  
  # for display in project_submissions#select_project_submission_for_grading
   def self.eager_load_project_submissions_for(project)
     self.includes(:pictures, :user).find(:all, :conditions=>{
       :project_id => project.id 
     })
   end
   

   def update_submission_data(picture)
     if self.first_submission_time.nil?
       self.first_submission_time = picture.created_at
     end
     
     # puts "********************Gonna update submission data\n"*100
     if picture.is_original?
       self.total_original_submission += 1
     end 

     self.total_picture_submission += 1 
     self.save
   end
   
   # def refresh_submission
   #    self.total_original_submission = self.original_pictures.count
   #    self.total_picture_submission = self.pictures.count 
   #    self.save
   #  end
   
   
   # def clean_data
   #   self.total_original_submission = self.original_pictures.count
   #   self.total_picture_submission = self.pictures.count
   #   self.save
   # end
   
   # Update the server
   # Utility method
   def self.update_submission_data
     self.all.each do |project_submission|
       all_pictures = project_submission.pictures 
       if all_pictures.count > 0  
         project_submission.first_submission_time = all_pictures.first.created_at
         project_submission.total_original_submission = project_submission.original_pictures.count 
         project_submission.total_picture_submission = all_pictures.count
       end 
       project_submission.save 
     end
   end
   
   
   def update_total_project_score
     
   end
  
  
end
