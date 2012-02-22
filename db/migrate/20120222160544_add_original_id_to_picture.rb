class AddOriginalIdToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :original_id, :integer, :default => nil
  end
end
