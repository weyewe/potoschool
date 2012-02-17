class Group < ActiveRecord::Base
  belongs_to :course
  
  has_many :users, :through => :group_memberships
  has_many :group_memberships
  
  def add_member( user ) 
    GroupMembership.create :user_id => user.id, :group_id => self.id 
  end
  
  
  def students
    self.users 
  end
  
  
  def has_student( student )
    not GroupMembership.find(:first, :conditions => {
      :user_id => student.id,
      :group_id => group.id 
    }).nil?
  end
        
        
end
