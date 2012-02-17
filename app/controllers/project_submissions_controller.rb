class ProjectSubmissionsController < ApplicationController
  def index
    # assume that current user is student 
    
    @project_submissions = ProjectSubmission.find(:all, :conditions => {
      :user_id => current_user.id
    })
    
    add_breadcrumb "Select Project", "project_submissions_url"
    
  end
end
