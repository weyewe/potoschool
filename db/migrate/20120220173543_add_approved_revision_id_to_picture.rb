class AddApprovedRevisionIdToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :approved_revision_id, :integer, :default => nil 
  end
end
