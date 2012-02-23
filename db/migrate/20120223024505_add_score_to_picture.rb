class AddScoreToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :score , :integer, :default => 0
  end
end
