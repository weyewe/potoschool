class CreateCourseTeachingAssignments < ActiveRecord::Migration
  def change
    create_table :course_teaching_assignments do |t|
      
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end
  end
end
