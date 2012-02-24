class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      
      t.string   :event_type, :subject_type,  :actor_type,  :secondary_subject_type
      t.integer               :subject_id,    :actor_id,    :secondary_subject_id
      
      

      t.timestamps
    end
  end
end
