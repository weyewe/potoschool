class CreateSubjectTeachingAssignments < ActiveRecord::Migration
  def change
    create_table :subject_teaching_assignments do |t|
      t.integer :subject_id
      t.integer :user_id

      t.timestamps
    end
  end
end
