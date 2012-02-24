class UserActivity < ActiveRecord::Base
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
  
  
  def self.create_new_entry(event, actor, subject , secondary_subject)
    options = {}
    options[:event_type] = event 
    options[:actor_type] = actor.class.to_s
    options[:actor_id]  = actor.id 
    
    options[:subject_type] = subject.class.to_s
    options[:subject_id]  = subject.id 
    
    if not secondary_subject.nil?
      # for example: willy replied on your comment -> 
        # what is affected => subject (comment), is created  as a reply for the root comment 
        # => the root comment is affected as well since it has extra reply now 
      options[:secondary_subject_type]  = secondary_subject.class.to_s
      options[:secondary_subject_id]  = secondary_subject.id 
    end
    
    self.create( options ) 
          
  end
end
