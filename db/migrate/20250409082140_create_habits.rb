class CreateHabits < ActiveRecord::Migration[8.0]
  def change
    create_table :habits do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.integer :duration
      t.boolean :reminder
      t.string :icon

      t.timestamps
    end
  end
end
