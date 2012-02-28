class AddActiveConditionToAllRegistrationOrAssignment < ActiveRecord::Migration
  def change
    # the basic subject & course table 
    add_column :subjects, :is_active, :boolean, :default => true 
    add_column :courses, :is_active, :boolean, :default => true 
    
    # the assignmnet for teacher 
    add_column :subject_teaching_assignments, :is_active, :boolean , :default => true 
    add_column :course_teaching_assignments, :is_active, :boolean, :default => true 
    
    # for the student registration
    add_column :subject_registrations, :is_active , :boolean, :default => true
    add_column :course_registrations, :is_active, :boolean, :default => true 
  end
end
