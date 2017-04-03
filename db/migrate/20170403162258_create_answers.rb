class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.belongs_to :secret_question, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.string :answer

      t.timestamps
    end
  end
end
