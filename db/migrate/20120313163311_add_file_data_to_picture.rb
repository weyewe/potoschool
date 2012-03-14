class AddFileDataToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :doc_id, :string 
    add_column :pictures, :doc_access_key, :string 
    add_column :pictures, :picture_filetype, :integer , :default => PICTURE_FILETYPE[:image]
    add_column :pictures, :conversion_status , :boolean, :default => false 
  end
end
