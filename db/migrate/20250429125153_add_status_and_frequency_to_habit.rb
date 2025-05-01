class AddStatusAndFrequencyToHabit < ActiveRecord::Migration[8.0]
  def change
    add_column :habits, :status, :string
    add_column :habits, :frequency, :integer
  end
end
