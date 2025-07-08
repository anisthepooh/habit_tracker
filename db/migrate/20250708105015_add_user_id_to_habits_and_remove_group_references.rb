class AddUserIdToHabitsAndRemoveGroupReferences < ActiveRecord::Migration[8.0]
  def change
    # Add user_id to habits table
    add_reference :habits, :user, null: true, foreign_key: true
    
    # Migrate existing data: populate user_id from group relationships
    # Each habit gets the user_id from the first user in its group
    reversible do |dir|
      dir.up do
        # Disable foreign key checks temporarily
        execute "PRAGMA foreign_keys = OFF"
        
        # Direct SQL to avoid ActiveRecord associations that no longer exist
        execute <<-SQL
          UPDATE habits 
          SET user_id = (
            SELECT users.id 
            FROM users 
            WHERE users.group_id = habits.group_id 
            LIMIT 1
          )
          WHERE habits.group_id IS NOT NULL
        SQL
        
        # Delete entries for habits that couldn't be assigned to a user
        execute "DELETE FROM entries WHERE habit_id IN (SELECT id FROM habits WHERE user_id IS NULL)"
        
        # Delete any habits that couldn't be assigned to a user
        execute "DELETE FROM habits WHERE user_id IS NULL"
        
        # Re-enable foreign key checks
        execute "PRAGMA foreign_keys = ON"
      end
    end
    
    # Make user_id non-nullable after data migration
    change_column_null :habits, :user_id, false
    
    # Remove group_id from habits
    remove_foreign_key :habits, :groups
    remove_reference :habits, :group
    
    # Remove group_id from users
    remove_foreign_key :users, :groups
    remove_reference :users, :group
    
    # Drop groups table
    drop_table :groups do |t|
      t.string :name
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
