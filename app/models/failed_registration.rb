class FailedRegistration < ActiveRecord::Base
  belongs_to :school
  
  
  def self.send_all_failed_registration
    destination = ["rajakuraemas@gmail.com", "w.yunnal@gmail.com", "christian.tanudjaja@gmail.com"]
    puts "before the delayed job"
    self.delay.execute_send_all_failed_registration(destination)
  end
  
  def self.execute_send_all_failed_registration(email)
    puts "delayed job execution"
    NewsletterMailer.importing_update( email ).deliver
  end
end
