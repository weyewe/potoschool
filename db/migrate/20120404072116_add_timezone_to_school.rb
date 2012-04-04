class AddTimezoneToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :time_zone, :string, :limit => 255 , :default => "UTC"
  end
end
