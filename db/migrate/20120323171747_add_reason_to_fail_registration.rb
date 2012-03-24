class AddReasonToFailRegistration < ActiveRecord::Migration
  def change
    add_column :failed_registrations, :reason, :text
  end
end
