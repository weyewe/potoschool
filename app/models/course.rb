class Course < ActiveRecord::Base
  belongs_to :subject
  
  # teacher has many course through course teaching assignment
  has_many :users, :through => :course_teaching_assignments
  has_many :course_teaching_assignments
  
  
  # student, registering for the course 
  has_many :users, :through => :course_registrations
  has_many :course_registrations
  
  #course has many groups
  has_many :groups
  
  has_many :projects 
  belongs_to :term 
  after_create :hook_to_term
  
  
  def hook_to_term
    self.term_id = self.subject.term_id 
    self.save
  end
  
  #  wtf is this?
  def teachers_count_for(subject)
    self.course_teaching_assignments.where(:course_id => self.id ).count
  end
  
  def students
    self.course_registrations
  end
  
  def teachers
    self.course_teaching_assignments
  end
  
  
  def students_list
    self.students
  end
  
  
  def teachers_list
    self.teachers.map{ |x| x.user }
  end
  
  
  def create_group( group_name )
    self.groups.create :name => group_name 
  end
  
=begin
Teacher code
=end

  def add_teacher(teacher)
    CourseTeachingAssignment.create :user_id => teacher.id, :course_id => self.id
  end
  
  def create_project_with_submissions(project_hash)
    project = self.projects.new(project_hash)
    if project.save 
      project.create_project_submissions
    else
      return project
    end
    return project
  end
  
  def get_closed_projects
    self.projects.where(:is_active => false )
  end
  
  def get_score_for(student, project)
    project_submission = ProjectSubmission.find(:first, :conditions => {
      :user_id => student.id, 
      :project_id => project.id 
    })
    
    if not project_submission.nil?
      return project_submission.score
    else
      return nil
    end
  end
  
=begin
Student code
=end

  def add_student( student )
    CourseRegistration.create :user_id => student.id, :course_id => self.id
  end
  
  def students
    course  = self 
    User.joins(:course_registrations =>:course).
      where(:course_registrations => {:course => {:id => course.id }})
  end
  
  # Subject.joins(:subject_teaching_assignments => :user ).
  #        where(:subject_teaching_assignments => {:user => {:id => self.id } } )
  
  
  # for project
 
end
