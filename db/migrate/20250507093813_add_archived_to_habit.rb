class AddArchivedToHabit < ActiveRecord::Migration[8.0]
  def change
    add_column :habits, :archived, :boolean, default: false
  end
end
