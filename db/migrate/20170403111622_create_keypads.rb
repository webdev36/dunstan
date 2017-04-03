class CreateKeypads < ActiveRecord::Migration[5.0]
  def change
    create_table :keypads do |t|
      t.string :number
      t.string :password
      t.string :code
      t.string :status
      t.belongs_to :admin, foreign_key: true

      t.timestamps
    end
  end
end
