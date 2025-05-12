class CreateAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email
      t.string :role

      t.timestamps
    end
  end
end
