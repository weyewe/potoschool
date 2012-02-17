class CreateProjectSubmissions < ActiveRecord::Migration
  def change
    create_table :project_submissions do |t|
      
      t.integer :project_id
      t.integer :user_id
      t.boolean :is_approved, :default => nil
      t.integer :approved_submission_id 
      t.datetime :approval_time 

      t.timestamps
    end
  end
end
