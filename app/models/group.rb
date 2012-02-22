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
  
  def group_leader
    if self.group_leader_id.nil?
      return nil
    end
      
    User.find_by_id( self.group_leader_id)
  end
        
        
  def add_group_leader(user)
    self.group_leader_id = user.id
    self.save
  end
  
  def remove_group_leader(user)
    if self.group_leader_id == user.id
      self.group_leader_id = nil
      self.save
    end
  end
  
  
        
end
