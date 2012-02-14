class Role < ActiveRecord::Base
  has_many :assignments
  has_many :enrollments, :through => :assignments
end
