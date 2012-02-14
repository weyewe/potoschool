module ApplicationHelper
  ACTIVE = 'active'
  
  def create_guide(title, description)
    result = ""
    result << "<div class='explanation-unit'>"
    result << "<h1>#{title}</h1>"
    result << "<p>#{description}</p>"
    result << "</div>"
  end
  
  
  
  
  
  
  
  
  def get_process_nav( symbol, params)
    
    if symbol == :school_admin
      return create_process_nav(SCHOOL_ADMIN_PROCESS_LIST, params )
    end
    
    if symbol == :teacher
      return create_process_nav(TEACHER_PROCESS_LIST, params )
    end
    
    if symbol == :student 
      return create_process_nav(STUDENT_PROCESS_LIST, params )
    end
  end
  
  
  
  
  protected 
  
  #######################################################
  #####
  #####     Start of the process navigation code 
  #####
  #######################################################
   
  def create_process_nav( process_list, params )
     result = ""
     result << "<ul class='nav nav-list'>"
     result << "<li class='nav-header'>  "  + 
                 process_list[:header_title] + 
                 "</li>"         

     process_list[:processes].each do |process|
       result << create_process_entry( process, params )
     end

     result << "</ul>"

     return result
   end
   
   
  
  
  
  def create_process_entry( process, params )
    is_active = is_process_active?( process[:conditions], params)
    
    process_entry = ""
    process_entry << "<li class='#{is_active}'>" + 
                      link_to( process[:title] , extract_url( process[:destination_link] )    )
    
    return process_entry
  end
  
  def is_process_active?( active_conditions, params  )
    active_conditions.each do |condition|
      if condition[:controller] == params[:controller] &&
        condition[:action] == params[:action]
        return ACTIVE
      end

    end

    return ""
  end
  
  def extract_url( some_url )
    if some_url == '#'
      return '#'
    end
    
    eval( some_url ) 
  end
  
  
  
  #######################################################
  #####
  #####     Start of the process navigation KONSTANT
  #####
  #######################################################
  
  SCHOOL_ADMIN_PROCESS_LIST = {
    :header_title => "SCHOOL ADMIN",
    :processes => [
     {
       :title => "Add Teacher",
       :destination_link => "new_teacher_url",
       :conditions => [
         {
           :controller => "enrollments", 
           :action => "new_teacher"
         }
       ]

     },
     {
       :title => "Add Student",
       :destination_link => "new_student_url",
       :conditions => [
         {
           :controller => "enrollments", 
           :action => "new_student"
          }
         ]
       },
       {
          :title => "Create Subject",
          :destination_link => "new_subject_url",
          :conditions => [
            {
              :controller => "subjects", 
              :action => "new"
             }
            ]
        }
      ]
    }
  

  
  
  
end
