class Project < ActiveRecord::Base
  belongs_to :course 

  
  # student project submission
  has_many :users, :through => :project_submissions
  has_many :project_submissions
  
  
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
