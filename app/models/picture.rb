class Picture < ActiveRecord::Base
  belongs_to :project_submission
  
  # so that we can call @picture.revisions
  # and @revision.original_picture
  has_many :revisions, :class_name => "Revision"
  belongs_to :original_picture, :class_name => "Revision",
    :foreign_key => "original_picture_id"
    
    # class Employee < ActiveRecord::Base
    #   has_many :subordinates, :class_name => "Employee"
    #   belongs_to :manager, :class_name => "Employee",
    #     :foreign_key => "manager_id"
    # end
    # We can do this shit: @employee.subordinates and @employee.manager.
    
  acts_as_commentable
  
end
