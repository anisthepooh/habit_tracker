class CreateEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :entries do |t|
      t.datetime :date
      t.string :description
      t.string :mood
      t.references :habit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
