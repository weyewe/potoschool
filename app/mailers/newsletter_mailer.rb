class NewsletterMailer < ActionMailer::Base
  # helper UserActivityMailerHelper
  default :css => :bootstrap_email , from: "admin@potoschool.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.newsletter_mailer.weekly.subject
  #
  def activity_update(email, time, user_activity )
    extract_params(user_activity) 
    @user_activity = user_activity
    
    
    
    mail( :to  => email, 
    :subject => "potoSchool | Tarumanegara Updates new #{time}" )# ,
    #     :actor => @actor,
    #     :subject => @subject,
    #     :secondary_subject  => @secondary_subject,
    #     :event_type => @event_type  )

    user_activity.mark_notification_sent # as long as this code is executed, we don't care
    # does the recipient actually receive it ? 


  end
  
  def send_summary(email)
    mail(:to => email , 
    :subject => "potoSchool | Summary Tarumangara @#{Time.now}")
  end
  
  
  def extract_params(user_activity)
    @actor = user_activity.extract_object(:actor)
    @subject = user_activity.extract_object(:subject)
    @secondary_subject = user_activity.extract_object(:secondary_subject)
    @event_type = user_activity.event_type
  end
end
