class AddIsGradedToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :is_graded, :boolean, :default => false
  end
end
