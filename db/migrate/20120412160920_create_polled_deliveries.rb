class CreatePolledDeliveries < ActiveRecord::Migration
  def change
    create_table :polled_deliveries do |t|
      t.boolean :is_delivered, :default => false 
      
      t.string :recipient_email
      t.integer :user_activity_id 
      t.time :notification_raised_time
      
      
      t.timestamps
    end
  end
end
