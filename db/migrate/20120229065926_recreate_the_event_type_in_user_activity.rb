class RecreateTheEventTypeInUserActivity < ActiveRecord::Migration
  def up
    add_column :user_activities, :event_type , :integer 
  end

  def down
    remove_column :user_activities, :event_type 
  end
end
