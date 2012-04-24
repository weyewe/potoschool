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
    self.pictures.where(:is_original => true , :is_deleted => false ).order("created_at ASC")
  end
  
  def original_pictures_id
    self.pictures.where(:is_original => true , :is_deleted => false ).order("created_at ASC").select(:id).map do |x|
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

  def update_score
    self.score = self.max_grade
    self.save 
  end

  def self.refresh_score
    self.all.each do |project_submission|
      total_score = 0 
      total_upload = project_submission.project.total_submission 
      
      project_submission.original_pictures.each do |x| 
        if not x.score.nil?
          total_score += x.score
        end
        
      end
      
      project_submission.score = total_score.to_f  / total_upload 
      project_submission.save 
    end
  end

  # can be commented 
  # acts_as_commentable
  
  
  
  # for display in project_submissions#select_project_submission_for_grading
   def self.eager_load_project_submissions_for(project)
     self.includes(:pictures, :user).find(:all, :conditions=>{
       :project_id => project.id 
     }, :order => "created_at ASC")
   end
   

   def update_submission_data(picture)
     if self.first_submission_time.nil?
       self.first_submission_time = picture.created_at
     end
     
     # # puts "********************Gonna update submission data\n"*100
     #      if picture.is_original?
     #        self.total_original_submission += 1
     #      end 
     # 
     #      self.total_picture_submission += 1 
     #      self.save
     
     self.total_original_submission = self.original_pictures.where(:is_deleted => false).count
     self.total_picture_submission = self.pictures.where(:is_deleted => false ).count
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
  
  
  def exceed_quota?
    project = self.project 
    self.original_pictures.count  >= project.total_submission
  end 
  
=begin
  Show grading 
=end

  def max_grade
    graded_pictures_count = self.pictures.where(:is_deleted=> false, :is_graded => true).count
    if graded_pictures_count == 0 
      return nil
    else
      return self.pictures.
              where(:is_deleted=> false, :is_graded => true).
              maximum("score")
    end
  end
  
  def has_score?
     not self.max_grade.nil?
  end
  
end
