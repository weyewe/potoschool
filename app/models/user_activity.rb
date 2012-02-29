class UserActivity < ActiveRecord::Base
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
  
  
  after_create :deliver_update
  
  
  
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
  
  def deliver_update
    self.delay.send_user_activity_update
  end
  
  
=begin
  Extracting the value 
    Actor (the one who did something to subject)
    Subject ( the one who receive an action from actor)
    Secondary subject ( the collateral impact )
=end
  def extract_object(symbol)
    symbol = symbol.to_s
    extraction_type = "#{symbol}_type"
    extraction_id = "#{symbol}_id"
    
    extraction_class = eval( "self." + "#{extraction_type}")
    extraction_id = eval( "self." + "#{extraction_id}" )
    command = "#{extraction_class}" + "." + "find_by_id(#{extraction_id})"
    puts command 
    object =   eval( command )
    
    return object
  end

=begin
a  = UserActivity.find(:first, :conditions => {
  :event_type => EVENT_TYPE[:submit_picture]
})
=end

  
  
  def mark_notification_sent
    self.is_notification_sent = true
    self.save 
  end
  
  
  
  # protected
  
  def self.send_summary
    NewsletterMailer.send_summary("rajakuraemas@gmail.com").deliver
  end

  def send_user_activity_update
    NewsletterMailer.activity_update("rajakuraemas@gmail.com", Time.now, self).deliver
  end
end
