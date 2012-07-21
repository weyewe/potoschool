class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      
      t.integer :school_id
      t.string :title
      t.text :description 

      t.timestamps
    end
  end
end
