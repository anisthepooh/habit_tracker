class AddTimezoneToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :timezone, :string, default: 'UTC'
    add_column :users, :push_subscription_data, :text # JSON for future push notifications
  end
end
