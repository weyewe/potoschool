Debita46::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  resources :users 
  
  match 'dashboard'           => 'home#dashboard'  , :as => :dashboard
  root :to => 'home#dashboard'
  
  match 'raise_exception' => 'home#raise_exception', :as => :raise_exception 
  
  # to create teacher, create students , to create admin
  resources :enrollments
  resources :subjects do
    resources :courses 
    resources :subject_teaching_assignments
    # for student 
    resources :subject_registrations 
  end
  
  resources :courses do 
    resources :course_teaching_assignments
    #for student 
    resources :course_registrations
    resources :projects
    resources :groups
  end
  
  resources :projects
  resources :project_submissions
  resources :project_submissions do 
    resources :pictures
  end
  resources :user do 
    resources :project_submissions
  end
  
  resources :groups do 
    resources :group_memberships
  end
  resources :group_memberships
  
  match 'active_subjects_management' => "subjects#active_subjects_management", :as => :active_subjects_management
  match 'passive_subjects_management' => "subjects#passive_subjects_management", :as => :passive_subjects_management
  match 'duplicate_active_subject/:subject_id' => "subjects#duplicate_active_subject" , :as => :duplicate_active_subject
  match 'duplicate_passive_subject/:subject_id' => "subjects#duplicate_passive_subject" , :as => :duplicate_passive_subject
  
  match 'execute_duplicate_subject' => "subjects#execute_duplicate_subject" , :as => :execute_duplicate_subject, :method => :post 
  match 'close_subject' => "subjects#close_subject", :as => :close_subject, :method => :post 
  match 'recover_subject' => "subjects#recover_subject", :as => :recover_subject, :method => :post 
  
  # assign teacher to the subject and course 
  # use the course_teaching assignment 
  # use the subject_teaching_assignments
  # and these named routes 
  match 'new_subject_teaching_assignment' => "subjects#new_subject_teaching_assignment", :as => :new_subject_teaching_assignment
  match 'pick_subject_for_course_teaching_assignment' => "courses#pick_subject_for_course_teaching_assignment", :as => :pick_subject_for_course_teaching_assignment
  match 'new_course_teaching_assignment/:subject_id' => "courses#new_course_teaching_assignment", :as => :new_course_teaching_assignment
  
  match 'select_course_for_grade_summary' => "courses#select_course_for_grade_summary", :as => :select_course_for_grade_summary 
  match 'show_student_grades_for_course/:course_id' => "courses#show_student_grades_for_course", :as => :show_student_grades_for_course 
  match 'show_project_grading_details/project/:project_id/student/:student_id' => "courses#show_project_grading_details", :as => :show_project_grading_details 
  
  # assign student to the subject and course 
  # use the subject_registrations  
  # use the course_registrations 
  # and these named routes
  
  match 'pick_subject_for_student_registrations' => "subject_registrations#pick_subject_for_student_registrations", :as => :pick_subject_for_student_registrations
  
  match 'select_subject_for_course_registration' => "course_registrations#select_subject_for_course_registration", :as => :select_subject_for_course_registration
  match 'select_course_for_course_registration/subject/:subject_id' => "course_registrations#select_course_for_course_registration", :as => :select_course_for_course_registration
  
  match 'new_teacher'           => 'enrollments#new_teacher'  , :as => :new_teacher
  match 'new_student'           => 'enrollments#new_student'  , :as => :new_student
  
  
  # FOR THE TEACHER
  #   create project for course (can be group project or personal project) 
  match 'select_subject_for_project' => "projects#select_subject_for_project", :as => :select_subject_for_project
  match 'select_course_for_project/subject/:subject_id' => "projects#select_course_for_project", :as => :select_course_for_project
  match 'close_project' => "projects#close_project", :as => :close_project, :method => :post 
  match 'recover_project' => "projects#recover_project", :as => :recover_project, :method => :post 
  match 'past_projects' => "projects#past_projects", :as => :past_projects
  
  match 'select_active_project_to_be_edited' => "projects#select_active_project_to_be_edited", :as => :select_active_project_to_be_edited
  
  # create group for course
  match 'select_subject_for_group' => "groups#select_subject_for_group", :as => :select_subject_for_group
  match 'select_course_for_group/subject/:subject_id' => "groups#select_course_for_group", :as => :select_course_for_group
  match 'select_group_for_group_leader' => "groups#select_group_for_group_leader", :as => :select_group_for_group_leader
  match 'select_group_leader/group/:group_id' => "groups#select_group_leader", :as => :select_group_leader, :method => :post
  match 'execute_select_group_leader' => "groups#execute_select_group_leader", :as => :execute_select_group_leader, :method => :post
  
  
  # for group membership assignment
  match 'select_subject_for_group_membership' => "group_memberships#select_subject_for_group_membership", :as => :select_subject_for_group_membership
  match 'select_course_for_group_membership/subject/:subject_id' => "group_memberships#select_course_for_group_membership", :as => :select_course_for_group_membership
  match 'select_group/course/:course_id' => "group_memberships#select_group", :as => :select_group
  
  
  # grading the project submission
  match 'project_submissions_display' => "project_submissions#project_submissions_display", :as => :project_submissions_display
  match 'select_project_for_grading' => "projects#select_project_for_grading", :as => :select_project_for_grading
  match 'select_project_submission_for_grading/project/:project_id' => "project_submissions#select_project_submission_for_grading", :as => :select_project_submission_for_grading
  match 'show_submission_pictures_for_grading/project_submission/:project_submission_id' => "project_submissions#show_submission_pictures_for_grading", :as => :show_submission_pictures_for_grading
  match 'grade_project_submission_picture/picture/:picture_id' => "pictures#grade_project_submission_picture", :as => :grade_project_submission_picture
  match 'execute_grading/picture/:picture_id' => "pictures#execute_grading", :as => :execute_grading, :method => :post
  
  
=begin
  FOR STUDENTS 
=end  
  match 'student_projects' => "projects#student_projects", :as => :student_projects
  
  # project submissions 
  match 'project_submissions/:project_submission_id/create_revision/:original_pic_id' => "pictures#create_revision", :as => :create_revision
  
  # picture has many comments
  resources :pictures do 
    resources :positional_comments
    resources :comments
  end
  
  # create child comment
  match 'first_child_comment/picture/:picture_id/comment/:root_comment_id' => "comments#create_first_child_comment", :as => :create_first_child_comment
  match 'create_child_comment/picture/:picture_id/comment/:root_comment_id' => "comments#create_child_comment", :as => :create_child_comment
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
