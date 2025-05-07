class CreateUserConfigurations < ActiveRecord::Migration[8.0]
  def change
    create_table :user_configurations do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :newsletter_accepted
      t.timestamps
    end
  end
end
