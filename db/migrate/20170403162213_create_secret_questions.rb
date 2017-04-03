class CreateSecretQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :secret_questions do |t|
      t.string :question

      t.timestamps
    end
  end
end
