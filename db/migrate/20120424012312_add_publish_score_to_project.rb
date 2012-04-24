class AddPublishScoreToProject < ActiveRecord::Migration
  def change
    add_column :projects, :publish_grade, :boolean , :default => false 
  end
end
