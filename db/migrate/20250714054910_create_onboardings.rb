class CreateOnboardings < ActiveRecord::Migration[8.0]
  def change
    create_table :onboardings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :guide_name, null: false
      t.datetime :viewed_at
      t.datetime :completed_at

      t.timestamps
    end
    
    add_index :onboardings, [:user_id, :guide_name], unique: true
  end
end
