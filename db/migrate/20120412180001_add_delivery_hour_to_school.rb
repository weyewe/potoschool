class AddDeliveryHourToSchool < ActiveRecord::Migration
  def change
    add_column :schools ,:delivery_method, :integer , :default => NOTIFICATION_DELIVERY_METHOD[:instant]
    add_column :schools ,:scheduled_delivery_hours , :string, :default => ""
  end
end
