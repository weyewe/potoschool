class AddActiveProject < ActiveRecord::Migration
  def up
    add_column :projects , :is_active, :boolean, :default => true 
  end

  def down
    remove_column :projects , :is_active
  end
end
