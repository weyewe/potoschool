class UserActivityMailerHelper
  
  
  def create_text_feed_entry(user_activity) 
  end
  
  def create_html_feed_entry(user_activity)
    # EVENT_TYPE  = {
    #   :create_comment => 1,  # added
    #   :reply_comment => 2,  #added 
    #   :submit_picture => 3 ,   #added
    #   :submit_picture_revision => 4,  #added 
    #   :grade_picture => 5,  # added   # rejected and approved 
    #   :create_project => 6   #added
    # }
    
    @actor = user_activity.extract_object :actor
    @subject  = user_activity.extract_object :subject
    @secondary_subject = user_activity.extract_object :secondary_subject
    
    
    case user_activity.event_type
    when EVENT_TYPE[:create_comment]
      # actor is the teacher 
      # subject is the picture  ### WRONG! Subject has to be the comment itself 
      # secondary subject is the project  ### SECONDARY_SUBJECT is the picture 
      
      title = "teacher wrote a feedback on project " 
      if not @secondary_subject.nil? 
        title << "with title #{@secondary_subject.title}"
      end

      return title 
    when EVENT_TYPE[:reply_comment]
      # actor is the user, can be teacher or student   
      # the subject is the previous comment
      # the secondary_subject is the root_comment
      
      if not @subject.nil? 
        commented_object = @subject.commented_object
        title = "xxx has just replied the discussion in project #{commented_object.project_submission.project.title}"
        return title 
      else
        return "xxx has just replied the discussion"
      end
        
      
    when EVENT_TYPE[:submit_picture]
      
    when EVENT_TYPE[:submit_picture_revision]
    when EVENT_TYPE[:grade_picture]
    when EVENT_TYPE[:create_project]
    else
    end
      
  end
  
  
  
end