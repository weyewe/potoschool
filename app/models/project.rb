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
  
  
  def format_deadline_date
    datetime = self.deadline_datetime
    "#{datetime.month}/#{datetime.day}/#{datetime.year}"
  end
  
  def passed_deadline?
    Time.now.to_datetime > self.deadline_datetime
  end
  
  def submission_has_exceed_quota(student)
    project_submission  = ProjectSubmission.find(:first, :conditions => {
      :user_id => student.id,
      :project_id => self.id 
    })
    
    project_submission.exceed_quota?
  end
  
  def is_closed?
    self.is_active == false 
  end
  
  def in_between_starting_and_deadline_time?
    current_time = Time.now.to_datetime
    deadline_time = ''
    starting_time = ''
    
    if self.deadline_datetime.nil?
      deadline_time = current_time 
    else
      deadline_time = self.deadline_datetime
    end
    
    if self.starting_datetime.nil?
      starting_time = current_time 
    else
      starting_time = self.starting_datetime
    end
    
    (current_time <=  deadline_time) && (current_time >= starting_time )
  end
  
  def earlier_than_starting_time?(current_time )
    current_time < starting_datetime
  end
  
  def later_than_deadline_time?(current_time )
    current_time > deadline_datetime
  end
  
  def possible_to_upload_more?(student)
    # 1. time <= deadline_datetime
    # 2. hasn't exceeded quota
    # 3. project is not closed 
    
    ( self.in_between_starting_and_deadline_time? ) and 
    (not self.submission_has_exceed_quota(student) ) and 
    (not  self.is_closed?)
    
  end
  
  def allow_student_activities?
    ( self.in_between_starting_and_deadline_time? ) and 
    (not self.is_closed?)
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

=begin
  Time display logic
=end
  def get_starting_datetime_local_time
    school = self.course.subject.school 
    self.starting_datetime.in_time_zone(school.get_time_zone)
  end
  
  def get_deadline_datetime_local_time
    school = self.course.subject.school 
    self.deadline_datetime.in_time_zone(school.get_time_zone)
  end

  def starting_hour
    if self.starting_datetime.nil?
      return 0
    end
    
    self.get_starting_datetime_local_time.hour
  end
  
  def starting_minute
    if self.starting_datetime.nil?
      return 0
    end
    
    self.get_starting_datetime_local_time.min
  end
  
  def deadline_hour
    if self.starting_datetime.nil?
      return 0
    end
    
    self.get_deadline_datetime_local_time.hour
  end
  
  def deadline_minute
    if self.starting_datetime.nil?
      return 0
    end
    
    self.get_deadline_datetime_local_time.min
  end
  
  
  
 
end
