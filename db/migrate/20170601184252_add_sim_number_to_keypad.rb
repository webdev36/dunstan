class AddSimNumberToKeypad < ActiveRecord::Migration[5.0]
  def change
    add_column :keypads, :sim_number, :string
  end
end
