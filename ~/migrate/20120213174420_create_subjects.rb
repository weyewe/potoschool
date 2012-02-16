class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.integer :school_id
      t.string :code
      t.string :name
      t.text :description
      
      t.boolean :is_closed , :default => false  # closed , means that the subject is finished
      t.date :starting_date 
      t.date :ending_date 

      t.timestamps
    end
  end
end
