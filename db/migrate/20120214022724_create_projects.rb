class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      
      t.string :title
      t.text :description
      t.boolean :is_group_project , :default => false 
      t.date :deadline_date
      t.time :deadline_time 

      t.timestamps
    end
  end
end
