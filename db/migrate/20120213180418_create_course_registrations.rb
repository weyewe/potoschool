class CreateCourseRegistrations < ActiveRecord::Migration
  def change
    create_table :course_registrations do |t|
      t.integer :course_id 
      t.integer :user_id

      t.timestamps
    end
  end
end
