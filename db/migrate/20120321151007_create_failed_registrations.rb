class CreateFailedRegistrations < ActiveRecord::Migration
  def change
    create_table :failed_registrations do |t|
      
      t.string :email
      t.string :nim
      t.string :name 
      t.string :subject_name
      t.string :course_name 
      t.integer :school_id 

      t.timestamps
    end
  end
end
