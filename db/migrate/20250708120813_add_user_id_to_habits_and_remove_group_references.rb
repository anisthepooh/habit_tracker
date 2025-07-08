class AddUserIdToHabitsAndRemoveGroupReferences < ActiveRecord::Migration[8.0]
  def up
    # Add user_id to habits table if it doesn't exist
    unless column_exists?(:habits, :user_id)
      add_column :habits, :user_id, :integer
      add_index :habits, :user_id
    end

    # Migrate data if groups table exists
    if table_exists?(:groups)
      # Enable foreign key constraints temporarily (SQLite specific)
      execute "PRAGMA foreign_keys = OFF"
      
      # Delete all entries first to avoid foreign key constraints
      Entry.delete_all
      
      # For each habit, find the user through the group association and set user_id
      execute <<-SQL
        UPDATE habits 
        SET user_id = (
          SELECT users.id 
          FROM users 
          WHERE users.group_id = habits.group_id 
          LIMIT 1
        )
        WHERE group_id IS NOT NULL
      SQL
      
      # Re-enable foreign key constraints
      execute "PRAGMA foreign_keys = ON"
      
      # Remove group_id column from habits
      if column_exists?(:habits, :group_id)
        remove_column :habits, :group_id
      end
      
      # Remove group_id column from users
      if column_exists?(:users, :group_id)
        remove_column :users, :group_id
      end
      
      # Drop groups table
      drop_table :groups
    end
  end

  def down
    # Recreate groups table
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.timestamps
    end

    # Add group_id back to users and habits
    add_column :users, :group_id, :integer unless column_exists?(:users, :group_id)
    add_column :habits, :group_id, :integer unless column_exists?(:habits, :group_id)
    
    # Remove user_id from habits
    remove_column :habits, :user_id if column_exists?(:habits, :user_id)
  end
end
