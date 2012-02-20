class AddIsApprovedToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :is_approved, :boolean, :default => nil
  end
end
