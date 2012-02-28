class AddScoreToProjectSubmission < ActiveRecord::Migration
  def change
    add_column :project_submissions, :score, :integer, :default => nil
  end
end
