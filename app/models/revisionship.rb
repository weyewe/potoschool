class Revisionship < ActiveRecord::Base
  # http://railscasts.com/episodes/163-self-referential-association
  belongs_to :picture
  belongs_to :revision, :class_name => "Picture"
end
