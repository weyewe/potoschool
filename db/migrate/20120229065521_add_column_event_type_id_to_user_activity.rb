class AddColumnEventTypeIdToUserActivity < ActiveRecord::Migration
  def change
    add_column :user_activities, :event_type_int, :integer 
  end
end
