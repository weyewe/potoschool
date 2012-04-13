class ChangeTimeToDatetimeInPolledDelivery < ActiveRecord::Migration
  def up
    add_column :polled_deliveries, :notification_raised_datetime, :datetime
  end

  def down
    remove_column :polled_deliveries, :notification_raised_datetime
  end
end


=begin
  PolledDelivery.all.each do |pd|
 
     pd.notification_raised_datetime = DateTime.new(
         2012,
         4,
         13,
         pd.notification_raised_time.hour,
         pd.notification_raised_time.min,
         pd.notification_raised_time.sec
     )
     pd.save
  end
=end