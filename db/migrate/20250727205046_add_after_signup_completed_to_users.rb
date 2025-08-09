class AddAfterSignupCompletedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :after_signup_completed, :boolean, default: false
  end
end
