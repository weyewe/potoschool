
class NewsletterMailer < ActionMailer::Base
  default :css => :bootstrap_email , from: "admin@potoschool.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.newsletter_mailer.weekly.subject
  #
  def weekly(email)

    mail( :to  => email, 
          :subject => "potoSchool | Tarumanegara Updates" ) 
  end
end
