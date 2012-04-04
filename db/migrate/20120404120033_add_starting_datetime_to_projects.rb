class AddStartingDatetimeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :starting_datetime,:datetime
  end
end
