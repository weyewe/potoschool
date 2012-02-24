class Project < ActiveRecord::Base
  belongs_to :course 

  
  # student project submission
  has_many :users, :through => :project_submissions
  has_many :project_submissions
  
  
  def Project.create_project_by_project_creator( project_creator , new_project)
    if new_project.save 
      # add_create_project_to_user_activity(EVENT_TYPE[:create_project]project_creator)
      UserActivity.create_new_entry(EVENT_TYPE[:create_project], 
                        project_creator, 
                        new_project , 
                        new_project.course )
                        
      return new_project
    else
      return nil
    end
  end
  
  def create_project_submissions
    students = self.course.students
    students.each do |student|
      ProjectSubmission.create :user_id => student.id, :project_id => self.id
    end
  end
  
  def group_project?
    self.is_group_project
  end
  

  
 
end
