class GroupMembership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  
  
=begin
  Process -> Select Subject, Select Course, Select Group, Assign Student 
  
  When it has to de-assign a student from a group in the other group, in order to 
  assign that student to the new group
=end


  def self.membership_update( group_id, user_id , decision )
    course = Group.find_by_id( group_id).course 
    
    
    group_membership = GroupMembership.find(:first, :conditions=>{
      :group_id => group_id,
      :user_id => user_id
    })
    
    course_groups_id = course.groups.collect{ |x| x.id }
    
    if decision == TRUE_CHECK
      # 1. destroy all group membership associated with this studnet in the 
      # current course 
      group_memberships = GroupMembership.find(:all, :conditions => {
        :group_id => course_groups_id , 
        :user_id => user_id 
      })
      
      group_memberships.each {|x| x.destroy }
      
      group_membership = GroupMembership.create :user_id => user_id, :group_id => group_id
      
      return group_membership 
      
      # 2. Then, create a new group membership based on the information provided 
    elsif decision == FALSE_CHECK
      # 1. destroy the group membership based on the information provided 
      group_membership = GroupMembership.find(:first, :conditions => {
        :user_id => user_id, :group_id => group_id 
      }).destroy 
      
      return group_membership
    end
        # 
        # if not group_membership.nil?
        #   # it was doing action toward itself 
        #   if decision == TRUE_CHECK # checking the checkbox
        #     # for some reason, there is a glitch.
        #     return group_membership
        #   elsif decision == FALSE_CHECK
        #     group_membership.destroy 
        #   end
        # else
        #   # there is no such group_membership 
        #   if decision == FALSE_CHECK
        #     return 
        #   elsif decision == TRUE_CHECK 
        #     GroupMembership.create :group_id => group_id, :user_id => user_id
        #   end
        # end
  end
  
end
