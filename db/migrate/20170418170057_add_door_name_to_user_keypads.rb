class AddDoorNameToUserKeypads < ActiveRecord::Migration[5.0]
  def change
    add_column :user_keypads, :door_name, :string
  end
end
