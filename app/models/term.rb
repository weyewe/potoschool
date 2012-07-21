class Term < ActiveRecord::Base
  belongs_to :school 
  has_many :projects 
  has_many :courses
  has_many :subjects 
end
