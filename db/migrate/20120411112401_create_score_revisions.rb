class CreateScoreRevisions < ActiveRecord::Migration
  def change
    create_table :score_revisions do |t|
      t.integer :picture_id 
      t.integer :old_score
      t.integer :new_score
      t.integer :score_reviser_id 
      t.timestamps
    end
  end
end
