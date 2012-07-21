class AddActiveStatusToTerm < ActiveRecord::Migration
  def change
    add_column :terms, :is_active, :boolean, :default => true 
  end
end
