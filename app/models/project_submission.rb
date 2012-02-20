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
    self.pictures.where(:is_original => true ).select(:id).map do |x|
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
     # Category.includes(:posts => [{:comments => :guest}, :tags]).find(1)
     # <td><%= project_submission.first_submission.created_at %></td>
     #   <td><%= project_submission.original_pictures.count %></td>  
     #   <td><%= project_submission.is_approved %></td>
     self.includes(:pictures, :user).find(:all, :conditions=>{
       :project_id => project.id 
     })
   end
   
   # def assign_first_submission(picture)
   #     # add_column :project_submissions, :first_submission_time, :datetime
   #     #      add_column :project_submissions, :total_original_submission, :integer, :default => 0
   #     #      add_column :project_submissions, :total_picture_submission, :integer, :default => 0
   #     self.first_submission_time = picture.created_at
   #     if picture.is_original?
   #       self.total_original_submission +=  1
   #     end
   #     self.total_picture_submission += 1 
   #     
   #     self.save
   #   end
   
   def update_submission_data(picture)
     if self.first_submission_time.nil?
       self.first_submission_time = picture.created_at
     end
     
     self.total_picture_submission += 1 
     self.total_original_submission += 1
     self.save
   end
   
   
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
  
  
end
