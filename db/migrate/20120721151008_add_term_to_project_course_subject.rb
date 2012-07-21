class AddTermToProjectCourseSubject < ActiveRecord::Migration
  def change
    add_column :projects, :term_id, :integer 
    add_column :courses, :term_id, :integer 
    add_column :subjects, :term_id, :integer 
  end
end
