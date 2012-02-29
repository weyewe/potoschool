class RemoveEventTypeIntFromUserActivity < ActiveRecord::Migration
  def up
    remove_column :user_activities, :event_type_int
  end

  def down
    add_column :user_activities, :event_type_int, :integer
  end
end
