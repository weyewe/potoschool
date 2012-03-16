class Project < ActiveRecord::Base
  belongs_to :course 

  
  # student project submission
  has_many :users, :through => :project_submissions
  has_many :project_submissions
  
  
  def Project.create_project_by_project_creator( project_creator , new_project)
    if new_project.save 
      # add_create_project_to_user_activity(EVENT_TYPE[:create_project]project_creator)
      
      if new_project.course 
        puts "The course is #{new_project.course.name}\n"*10
      else
        puts "The course is empty\n"*5
      end
      
      UserActivity.create_new_entry(EVENT_TYPE[:create_project], 
                        project_creator, 
                        new_project , 
                        new_project.course )
                        
      puts "Done with creating new user_activity in project"
                        
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
  
  def deactivate
    self.is_active = false
    self.save
  end
  
  def re_activate
    self.is_active = true
    self.save
  end
  
  def created_by?(current_user)
    if not current_user.has_role?(:teacher)
      return false 
    end
    
    not current_user.all_projects.where(:project_id => self.id ).nil?
  end

  
 
end
