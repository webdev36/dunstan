class CreateKeypadStates < ActiveRecord::Migration[5.0]
  def change
    create_table :keypad_states do |t|
      t.belongs_to :keypad, foreign_key: true
      t.string :open
      t.string :bell
      t.string :error
      t.string :power
      t.string :block
      t.string :status
      t.string :view

      t.timestamps
    end
  end
end
