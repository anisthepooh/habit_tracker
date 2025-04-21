class MoveGroupReferencesToUsersAndHabitsSecondAttempt < ActiveRecord::Migration[8.0]
  def change
    # Remove group info from groups table (it becomes "owning" rather than "linking")
    remove_column :groups, :user_id, :integer
    remove_column :groups, :habit_id, :integer

    # Add group_id to users and habits
    add_reference :users, :group, foreign_key: true, null: true
    add_reference :habits, :group, foreign_key: true, null: false
  end
end
