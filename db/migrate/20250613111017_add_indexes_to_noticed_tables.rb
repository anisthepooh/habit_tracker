class AddIndexesToNoticedTables < ActiveRecord::Migration[8.0]
  def change
    # Optimize the main communications query (created_at DESC with recipient)
    add_index :noticed_notifications, [:created_at], order: { created_at: :desc }, name: 'index_noticed_notifications_on_created_at_desc'
    
    # Note: recipient index already exists from noticed gem migration
    
    # Optimize monthly stats queries
    add_index :noticed_notifications, [:created_at, :type], name: 'index_noticed_notifications_on_created_at_and_type'
    
    # Optimize read status queries
    add_index :noticed_notifications, [:read_at], name: 'index_noticed_notifications_on_read_at'
  end
end
