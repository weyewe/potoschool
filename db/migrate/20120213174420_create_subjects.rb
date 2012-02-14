class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.integer :school_id
      t.string :code
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
