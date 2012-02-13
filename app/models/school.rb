class School < ActiveRecord::Base
  has_many :users, :through => :enrollments
  has_many :enrollments
  
  has_many :subjects
end
