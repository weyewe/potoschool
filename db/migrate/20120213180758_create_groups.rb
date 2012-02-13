class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      
      t.integer :course_id
      t.integer :group_leader_id

      t.timestamps
    end
  end
end
