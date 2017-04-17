class CreateKeypadHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :keypad_histories do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :keypad, foreign_key: true
      t.string :keypad_params

      t.timestamps
    end
  end
end
