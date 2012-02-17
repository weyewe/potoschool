class Project < ActiveRecord::Base
  belongs_to :course 

  
  # student project submission
  has_many :users, :through => :project_submissions
  has_many :project_submissions
end
