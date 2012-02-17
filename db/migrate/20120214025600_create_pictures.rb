class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name 

      t.integer :revision_id   # self referential association
      t.integer :project_submission_id # project_submission has many pictures 
      # the image url 
      t.string :original_image_url
      t.string :index_image_url
      t.string :revision_image_url
      t.string :display_image_url
      # the image size for billing 
      t.integer :original_image_size
      t.integer :index_image_size
      t.integer :revision_image_size
      t.integer :display_image_size
      
      # for logic
      t.boolean :is_deleted, :default => false 
      t.boolean :is_selected, :default => false 
      
      t.boolean :is_original, :default => false 
      
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
