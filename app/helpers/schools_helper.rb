module SchoolsHelper
  ACTIVE_STATUS = "active"
  
  def is_delivery_status_matched?(school, notification_delivery_method)
    if school.delivery_method == notification_delivery_method
      return "active"
    else
      return ""
    end
  end
  
  
  def selected_delivery_hours(school) 
    scheduled_delivery_hours = school.delivery_hours_in_school_timezone
    options = ""
    (0..23).each do |hour|
      # <option selected="selected">1</option>
      if scheduled_delivery_hours.include?( hour )
        options += "<option selected='selected'>#{hour}</option>"
      else
        options += "<option>#{hour}</option>"
      end
    end
    
    return options
    
  end
  
  def all_hours 
    (0..23).to_a
  end
    
  def hours_selected( school) 
     school.delivery_hours_in_school_timezone
  end
  
  
end
