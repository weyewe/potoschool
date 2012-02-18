Debita46::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  resources :users 
  
  match 'dashboard'           => 'home#dashboard'  , :as => :dashboard
  root :to => 'home#dashboard'
  
  
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
  
  
  # assign teacher to the subject and course 
  # use the course_teaching assignment 
  # use the subject_teaching_assignments
  # and these named routes 
  match 'new_subject_teaching_assignment' => "subjects#new_subject_teaching_assignment", :as => :new_subject_teaching_assignment
  match 'pick_subject_for_course_teaching_assignment' => "courses#pick_subject_for_course_teaching_assignment", :as => :pick_subject_for_course_teaching_assignment
  match 'new_course_teaching_assignment/:subject_id' => "courses#new_course_teaching_assignment", :as => :new_course_teaching_assignment
  
  
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

  # create group for course
  match 'select_subject_for_group' => "groups#select_subject_for_group", :as => :select_subject_for_group
  match 'select_course_for_group/subject/:subject_id' => "groups#select_course_for_group", :as => :select_course_for_group
  match 'select_group_for_group_leader' => "groups#select_group_for_group_leader", :as => :select_group_for_group_leader
  match 'select_group_leader/group/:group_id' => "groups#select_group_leader", :as => :select_group_leader, :method => :post
  
  # for group membership assignment
  match 'select_subject_for_group_membership' => "group_memberships#select_subject_for_group_membership", :as => :select_subject_for_group_membership
  match 'select_course_for_group_membership/subject/:subject_id' => "group_memberships#select_course_for_group_membership", :as => :select_course_for_group_membership
  match 'select_group/course/:course_id' => "group_memberships#select_group", :as => :select_group
  
  
  
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
