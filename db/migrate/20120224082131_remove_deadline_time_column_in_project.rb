class RemoveDeadlineTimeColumnInProject < ActiveRecord::Migration
  def up
    remove_column :projects, :deadline_time 
    remove_column :projects , :deadline_date 
    add_column :projects , :deadline_datetime, :datetime

  end

  def down
    add_column :projects, :deadline_time , :time
    add_column :projects, :deadline_date , :date
    remove_column :projects, :deadline_datetime 
  end
end
