class CreateChangelogEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :changelog_entries do |t|
      t.string :version
      t.date :date
      t.string :title
      t.text :description
      t.text :items
      t.string :image
      t.boolean :published
      t.datetime :publish_at

      t.timestamps
    end
  end
end
