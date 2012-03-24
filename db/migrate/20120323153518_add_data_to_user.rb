class AddDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :nim, :string
    add_column :users, :name, :string 
  end
end
