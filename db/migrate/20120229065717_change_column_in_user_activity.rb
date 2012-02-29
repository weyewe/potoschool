class ChangeColumnInUserActivity < ActiveRecord::Migration
  def up
    remove_column :user_activities, :event_type
  end

  def down
    add_column :user_activities, :event_type, :string 
  end
end
