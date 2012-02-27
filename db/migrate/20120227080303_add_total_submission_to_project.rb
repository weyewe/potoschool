class AddTotalSubmissionToProject < ActiveRecord::Migration
  def change
    add_column :projects, :total_submission, :integer
  end
end
