class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name 

      t.integer :original_picture_id  # self referential
      
      # images ?
      # and how did we control the next button in the images?
      # later, think about the design issue later.. now , admin issue 
      # big size
      # small size
      # any size? 
      
      
      t.timestamps
    end
  end
end
