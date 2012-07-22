# require 'rubygems'
# require 'openssl'
# require 'json'

module ApplicationHelper
  ACTIVE = 'active'
  REVISION_SELECTED = "selected"
  NEXT_BUTTON_TEXT = "Next &rarr;"
  PREV_BUTTON_TEXT = " &larr; Prev "
  
=begin
  Our version of transloadit 
=end
  
  def transloadit_with_max_size( template , size_mb )
    
    if Rails.env.production?
      transloadit_read = YAML::load( File.open( Rails.root.to_s + "/config/transloadit.yml") )
    elsif Rails.env.development?
      transloadit_read = YAML::load( File.open( Rails.root.to_s + "/config/transloadit_dev.yml") )
    end
    
    
    
    
    auth_key = transloadit_read['auth']['key']
    auth_secret = transloadit_read['auth']['secret']
    duration = transloadit_read['auth']['duration']
    template = transloadit_read['templates'][template]
  
    params = JSON.generate({
      :auth => {
        :expires => (Time.now + duration).utc.strftime('%Y/%m/%d %H:%M:%S+00:00') ,
      # Time.now.utc.strftime('%Y/%m/%d %H:%M:%S+00:00'),
        :key => auth_key,
        :max_size => size_mb*1024*1024
      },
      :template_id => template 
    })
    
    
    digest = OpenSSL::Digest::Digest.new('sha1')
    signature = OpenSSL::HMAC.hexdigest(digest, auth_secret, params)
    [params, signature]
  end
  
  
=begin  
  Picture Grading status
=end

  def get_picture_status_label(picture)
    result = ""
    if picture.is_approved.nil? 
      result = "<span class='label label-info'>Pending</span>"
    elsif picture.is_approved == true 
      result =  "<span class='label label-success'>Approved</span>"
    elsif picture.is_approved == false 
      result =  "<span class='label label-important'>Rejected</span>"
    end 
    return result
  end
  
=begin
  For positional comment
=end

  def adjust_marker_location( initial_spot_value  )
    initial_spot_value - ( POSITIONAL_COMMENT_MARKER_WIDTH/2  )
  end
  

=begin
  For gallery grading
=end

  def get_last_revision_score( original_picture, project )
    last_approved_revision = original_picture.last_approved_revision
    if last_approved_revision.is_graded == false 
      return gallery_grading_link("Pending", last_approved_revision, project)
    elsif  last_approved_revision.is_graded == true 
      return gallery_grading_link(last_approved_revision.score , last_approved_revision, project)
    end
  end
  
  def get_highest_score( original_picture , project )
    max_score = original_picture.highest_approved_pictures_score
    
    if max_score.nil?
      return  gallery_grading_link("Pending", original_picture, project)
    else
      return gallery_grading_link(max_score[1], original_picture, project) #max_score[1] # max_score.first[0] returns pic_id
    end
  end
  
  def gallery_grading_link( score, picture, project ) 
    link_to "#{score}", gallery_picture_grading_url( project, picture)
  end
  
  


=begin
  For project creation, select time and hour
=end

  def select_hour_options
    array = ""
    (0..23).each do |x|
      array << "<option>#{x}</option>"
    end
    return array 
  end
  
  def select_hour_options_with_selected(value)
    array = ""
    (0..23).each do |x|
      if x != value 
        array << "<option>#{x}</option>"
      else
        array << "<option selected='selected'>#{x}</option>"
      end
    end
    return array 
  end
  
  
  
  def select_minute_options
    array = ""
    (0..59).each do |x|
      array << "<option>#{x}</option>"
    end
    return array 
  end
  
  def select_minute_options_with_selected(value)
    array = ""
    (0..59).each do |x|
      if x != value 
        array << "<option>#{x}</option>"
      else
        array << "<option selected='selected'>#{x}</option>"
      end
    end
    return array 
  end
  
  def format_date_from_datetime( datetime) 
    if datetime.nil? 
      return ""
    end
    "#{datetime.month}/#{datetime.day}/#{datetime.year}"
  end
  
  def select_timezone_for_school( school )
    array = ""
    TOWN_OFFSET_HASH.sort_by {|key, value| value}.each do |loc_name, offset |
      if school.utc_offset == offset and school.time_zone == loc_name 
        array << "<option value='#{offset}_#{loc_name}' selected='selected'>#{loc_name} (GMT #{get_offset(offset)})</option>"
      else
        array << "<option value='#{offset}_#{loc_name}'>#{loc_name} (GMT #{get_offset(offset)})</option>"
      end
    end
    
    return array
  end
  
  def get_offset(offset)
    if offset.nil?
      return ""
    end
    if offset >= 0 
      "+ #{offset}"
    else
      "- #{offset}"
    end
  end
  
  
  
=begin
  For the grade display 
=end
  def get_colspan( closed_projects )
    length = closed_projects.length
    if length == 0 
      return 1 
    else
      return length 
    end
  end
  
  def extract_project_submission_result( result , student, project ) 
    if result.nil?
      return '-'
    else
      return  result #link_to result, show_project_grading_details_url(project, student )
    end
  end

=begin
  Getting prev and next button for the pictures#show
=end
  def get_next_project_picture( pic , is_grading_mode, is_gallery_mode)
    next_pic = pic.next_pic
    
    if not next_pic.nil?
      destination_url = ""
      if not is_grading_mode
        destination_url = project_submission_picture_url( pic.project_submission, next_pic)
      else
        destination_url = grade_project_submission_picture_url( next_pic ) 
      end
      
      if is_gallery_mode
        destination_url = gallery_picture_grading_url( pic.project_submission.project, next_pic)
        # link_to "#{score}", gallery_picture_grading_url( project, picture)
      end
      
      
      return  create_galery_navigation_button( NEXT_BUTTON_TEXT, "next",destination_url )
    else
      ""
    end
  end
  
  def get_previous_project_picture( pic , is_grading_mode, is_gallery_mode  )
    prev_pic = pic.prev_pic
    
    if not prev_pic.nil?
      
      destination_url = ""
      if not is_grading_mode
        destination_url = project_submission_picture_url( pic.project_submission, prev_pic)
      else
        destination_url = grade_project_submission_picture_url( prev_pic ) 
      end
      
      if is_gallery_mode
        destination_url = gallery_picture_grading_url( pic.project_submission.project, prev_pic)
        # link_to "#{score}", gallery_picture_grading_url( project, picture)
      end
      
      
      return  create_galery_navigation_button( PREV_BUTTON_TEXT, "previous", destination_url)
      
    else
      ""
    end
    
  end
  
  
  
  def create_galery_navigation_button( text, class_name, destination_url )
    button = ""
    button << "<li class=#{class_name}>"
    button << link_to("#{text}".html_safe, destination_url )
    button << "</li>"
    
  end
  
  # <li class="previous">
  #   <a href="#">&larr; Prev</a>
  # </li>
  # <li class="next">
  #   <a href="#">Next &rarr;</a>
  # </li>
  
  
  
=begin
  Showing the revisions in the pictures#show
=end
  
  def class_for_current_displayed_revision(revision, current_display)
    if revision.id == current_display.id 
      return REVISION_SELECTED
    else
      return ""
    end
  end
  
=begin
  Assigning activity:
  1. Assigning student to the class
  2. Assigning teacher to the course etc
=end
  
  def get_checkbox_value(checkbox_value )
    if checkbox_value == true
      return TRUE_CHECK
    else
      return FALSE_CHECK
    end
  end
  
  
=begin
  General command to create Guide in all pages
=end 
  def create_guide(title, description)
    result = ""
    result << "<div class='explanation-unit'>"
    result << "<h1>#{title}</h1>"
    result << "<p>#{description}</p>"
    result << "</div>"
  end
  
  def create_breadcrumb(breadcrumbs)
    
    if (  breadcrumbs.nil? ) || ( breadcrumbs.length ==  0) 
      # no breadcrumb. don't create 
    else
      breadcrumbs_result = ""
      breadcrumbs_result << "<ul class='breadcrumb'>"
      
      puts "After the first"
      
      
      breadcrumbs[0..-2].each do |txt, path|
        breadcrumbs_result  << create_breadcrumb_element(    link_to( txt, path ) ) 
      end 
      
      puts "After the loop"
      
      last_text = breadcrumbs.last.first
      last_path = breadcrumbs.last.last
      breadcrumbs_result << create_final_breadcrumb_element( link_to( last_text, last_path)  )
      breadcrumbs_result << "</ul>"
      return breadcrumbs_result
    end
    
    
  end
  
  def create_breadcrumb_element( link ) 
    element = ""
    element << "<li>"
    element << link
    element << "<span class='divider'>/</span>"
    element << "</li>"
    
    return element 
  end
  
  def create_final_breadcrumb_element( link )
    element = ""
    element << "<li class='active'>"
    element << link 
    element << "</li>"
    
    return element
  end
  
  
  
  
  

  
  
  
  
  
  
  
  
=begin
  Process Navigation related activity
=end  

  
  def get_process_nav( symbol, params)
    
    if symbol == :school_admin
      return create_process_nav(SCHOOL_ADMIN_PROCESS_LIST, params )
    end
    
    if symbol == :history 
      return create_process_nav(HISTORY_PROCESS_LIST, params )
    end
    
    if symbol == :teacher
      return create_process_nav(TEACHER_PROCESS_LIST, params )
    end
    
    if symbol == :submission_grading 
      return create_process_nav(SUBMISSION_GRADING_PROCESS_LIST, params )
    end
    
    if symbol == :student 
      return create_process_nav(STUDENT_PROCESS_LIST, params )
    end
    
    if symbol == :settings
      return create_process_nav(SETTINGS_PROCESS_LIST, params )
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
           :title => "Add Term",
           :destination_link => "new_term_url",
           :conditions => [
             {
               :controller => "terms", 
               :action => "new"
              },
              {
                :controller => "terms",
                :action => "create"
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
        },
        {
          :title => "Add Course",
          :destination_link => "subjects_url",
          :conditions => [
            {
              :controller => "subjects", 
              :action => "index"
            },
            {
              :controller => "courses",
              :action => "new"
            }
          ]
        },
        {
          :title => "Assign Teacher to Subject",
          :destination_link => "new_subject_teaching_assignment_url",
          :conditions => [
            {
              :controller => "subjects", 
              :action => "new_subject_teaching_assignment"
             },
             {
               :controller => "subject_teaching_assignments",
               :action => "new"
             }
            ]
        },
        {
          :title => "Assign Teacher to Course",
          :destination_link => "pick_subject_for_course_teaching_assignment_url",
          :conditions => [
            {
              :controller => "courses", 
              :action => "pick_subject_for_course_teaching_assignment"
             },
             {
               :controller => "courses",
               :action => "new_course_teaching_assignment"
             },
            {
              :controller => "course_teaching_assignments",
              :action => "new"
            }
          ]
        },
        {
          :title => "Assign Student to Subject",
          :destination_link => "pick_subject_for_student_registrations_url",
          :conditions => [
            {
              :controller => "subject_registrations", 
              :action => "pick_subject_for_student_registrations"
             },
             {
               :controller => "subject_registrations",
               :action => "new"
             }
          ]
        },
        {
          :title => "Assign Student to Course",
          :destination_link => "select_subject_for_course_registration_url",
          :conditions => [
            {
              :controller => "course_registrations", 
              :action => "select_subject_for_course_registration"
             },
             {
               :controller => "course_registrations",
               :action => "select_course_for_course_registration"
             },
            {
              :controller => "course_registrations",
              :action => "new"
            }
          ]
        },
        {
          :title => "Set Timezone",
          :destination_link => 'timezone_setup_url',
          :conditions => [
            {
              :controller => "schools",
              :action => "timezone_setup"
            }
          ]
        },
        {
          :title => "Notification Delivery",
          :destination_link => "delivery_method_setup_url",
          :conditions => [
            {
              :controller => "schools",
              :action => "delivery_method_setup"
            }
          ]
        }
      ]
    }
    
  HISTORY_PROCESS_LIST = {
    :header_title => "History",
    :processes => [
      {
        :title => "Active Subjects",
        :destination_link => "active_subjects_management_url", 
        :conditions => [
          {
            :controller => 'subjects',
            :action => 'active_subjects_management'
          },
          {
            :controller => 'subjects',
            :action => 'duplicate_active_subject'
          }
        ]
      },
      {
        :title => "Past Subjects",
        :destination_link => "passive_subjects_management_url",
        :conditions => [
          {
            :controller => 'subjects',
            :action => 'passive_subjects_management'
          },
          {
            :controller => "subjects",
            :action => 'duplicate_passive_subject'
          }
        ]
      },
      {
        :title => "Active Projects",
        :destination_link => "select_active_project_for_admin_url",
        :conditions => [
          {
            :controller => "projects",
            :action => "select_active_project_for_admin"
          },
          {
            :controller => "pictures",
            :action => "gallery_mode_active_project"
          },  
          {
              :controller => "projects",
              :action => "view_submission_rate"
          }
        ]
      }
    ]
  }
    
    
  TEACHER_PROCESS_LIST = {
    :header_title => "TEACHER",
    :processes => [
     {
       :title => "Create Project",
       :destination_link => "select_subject_for_project_url",
       :conditions => [
         {
           :controller => "projects", 
           :action => "select_subject_for_project"
         },
         {
            :controller => "projects", 
            :action => "select_course_for_project"
         }, 
         {
             :controller => "projects", 
             :action => "new"
         }
       ]
     },
     {
       :title => "Edit Project",
       :destination_link => "select_active_project_to_be_edited_url",
       :conditions => [
         {
           :controller => "projects",
           :action => "select_active_project_to_be_edited"
         },
         {
           :controller => "projects",
           :action => "edit"
         },
         {
           :controller => "projects",
           :action => "update"
         }
       ]
     },
     {
       :title => "Create Group",
       :destination_link => "select_subject_for_group_url",
       :conditions => [
         {
           :controller => "groups",
           :action => "select_subject_for_group"
         },
         {
           :controller => "groups",
           :action => "select_course_for_group"
         },
         {
           :controller => "groups",
           :action => "new"
         }
       ]
     },
     {
       :title => "Assign Student to Group",
       :destination_link => "select_subject_for_group_membership_path",
       :conditions => [
         {
           :controller => "group_memberships",
           :action => "select_subject_for_group_membership"
         },
         {
           :controller => "group_memberships",
           :action => "select_course_for_group_membership"
         },
         {
           :controller => "group_memberships",
           :action => "select_group"
         },
         {
           :controller => "group_memberships",
           :action => "new"
         }
       ]
     },
     {
       :title => "Select Group Leader",
       :destination_link => "select_group_for_group_leader_path",
       :conditions => [
         {
           :controller => "groups",
           :action => "select_group_for_group_leader"
         },
         {
           :controller => "groups",
           :action => "select_group_leader"
         }
       ]
     }
    ]
  }
  
  STUDENT_PROCESS_LIST = {
    :header_title => "Student",
    :processes => [
      {
        :title => "Ongoing Projects",
        :destination_link => 'project_submissions_url',
        :conditions => [
          {
            :controller => "project_submissions",
            :action => "index"
          },
          {
            :controller =>"pictures",
            :action => "new"
          },
          {
            :controller => "pictures",
            :action => "show"
          }
        ]
      }
    ]
  }
  
  SETTINGS_PROCESS_LIST = {
    :header_title => "Settings",
    :processes => [
      {
        :title => "Password",
        :destination_link => 'edit_credential_url',
        :conditions => [
          {
            :controller => "passwords",
            :action => "edit_credential"
          }
        ]
      }
    ]
  }
  
  
  
  SUBMISSION_GRADING_PROCESS_LIST = {
    :header_title => "Project Submission",
    :processes => [
      {
        :title => "Active Projects: Grading",
        :destination_link => "select_project_for_grading_url",
        :conditions => [
          {
            :controller => 'projects',
            :action => 'select_project_for_grading'
          },
          {
            :controller => 'project_submissions',
            :action => 'select_project_submission_for_grading'
          },
          {
            :controller => 'project_submissions',
            :action => 'show_submission_pictures_for_grading'
          },
          {
            :controller => 'pictures',
            :action => 'grade_project_submission_picture'
          },
          {
            :controller => "pictures",
            :action => 'gallery_mode_grading'
          },
          {
            :controller => "pictures",
            :action => "gallery_picture_grading"
          }
        ]
      },
      {
        :title => "Past Projects",
        :destination_link => 'past_projects_url' ,
        :conditions => [
          :controller => 'projects',
          :action => 'past_projects'
        ]
      },
      {
        :title => "Grade Summary",
        :destination_link => 'select_course_for_grade_summary_url',
        :conditions => [
          {
            :controller => 'courses',
            :action => 'select_course_for_grade_summary'
          },
          {
            :controller => 'courses',
            :action => 'show_student_grades_for_course'
          }
        ]
      },
      {
        :title => "Publish Project Grade",
        :destination_link => "select_project_to_publish_grade_url",
        :conditions => [
          {
            :controller => 'projects',
            :action => 'select_project_to_publish_grade'
          }
        ]
      },
      {
        :title => "Recent Submission",
        :destination_link => "select_project_for_grading_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          }
        ]
      },
      {
        :title => "Recent Comments",
        :destination_link => "select_project_for_grading_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          }
        ]
      }
    ]
  }
  
end
