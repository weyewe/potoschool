class AddRegistrationCodeToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :registration_code, :string 
  end
end
