class AddReminderFieldsToHabits < ActiveRecord::Migration[8.0]
  def change
    add_column :habits, :reminder_time, :time
    add_column :habits, :reminder_timezone, :string, default: 'UTC'
    add_column :habits, :reminder_enabled, :boolean, default: false
    add_column :habits, :last_reminder_sent_at, :datetime
    add_column :habits, :reminder_channels, :text # JSON array for future push notifications
    
    add_index :habits, [:reminder_enabled, :reminder_time]
  end
end
