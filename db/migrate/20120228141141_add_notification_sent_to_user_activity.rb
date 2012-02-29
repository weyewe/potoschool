class AddNotificationSentToUserActivity < ActiveRecord::Migration
  def change
    add_column :user_activities, :is_notification_sent , :boolean, :default => false 
  end
end
