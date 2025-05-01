class AddBackgroundToUserCard < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :card_background, :string
  end
end
