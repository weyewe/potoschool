class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.integer :school_id
      t.integer :user_id
      
      t.string :enrollment_code # has to be unique in one school

      t.timestamps
    end
  end
end
