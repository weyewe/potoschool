class SubjectsController < ApplicationController
  before_filter :ensure_has_school_admin_role
  
  def new
  end
  
  def create
  end
  
end
