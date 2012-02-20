class AddSubmissionDataToProjectSubmission < ActiveRecord::Migration
  def change
    add_column :project_submissions, :first_submission_time, :datetime
    add_column :project_submissions, :total_original_submission, :integer, :default => 0
    add_column :project_submissions, :total_picture_submission, :integer, :default => 0
    
  end
end
