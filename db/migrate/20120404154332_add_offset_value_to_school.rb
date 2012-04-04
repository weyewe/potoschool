class AddOffsetValueToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :utc_offset, :integer 
  end
end
