class AddThemeNumberToKeypad < ActiveRecord::Migration[5.0]
  def change
    add_column :keypads, :theme_number, :string
  end
end
