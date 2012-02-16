class CreateSubjectRegistrations < ActiveRecord::Migration
  def change
    create_table :subject_registrations do |t|
      t.integer :user_id
      t.integer :subject_id

      t.timestamps
    end
  end
end
