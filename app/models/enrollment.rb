class Enrollment < ActiveRecord::Base
  belongs_to :school
  belongs_to :user 
  
  # enrollment
  has_many :assignments
  has_many :roles, :through => :assignments
end
