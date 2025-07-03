class RemoveReminderTimezoneFromHabits < ActiveRecord::Migration[8.0]
  def change
    remove_column :habits, :reminder_timezone, :string
  end
end
