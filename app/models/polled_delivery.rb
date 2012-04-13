class PolledDelivery < ActiveRecord::Base
  def self.clear_all_pending_delivery( school ) 
    puts "Ahahaha, we are good. The shchool is #{school}"
    school.teachers.each do |teacher|
      pending_deliveries = PolledDelivery.find(:all, :conditions => {
        :recipient_email => teacher.email , 
        :is_delivered => false 
      }, :order => "notification_raised_time ASC")
      if pending.count > 0 
        # NewsletterMailer.welcome_email.deliver  # in rails 3, no need for .deliver
        NewsletterMailer.delay.polled_delivery( teacher.email, pending_deliveries )
      end
    end
     
  end
end
