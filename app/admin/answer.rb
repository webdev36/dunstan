ActiveAdmin.register Answer, as: "Answer" do
  permit_params :question
  index do
    selectable_column
    # id_column
    column :user
    column("Question"){|answer| answer.secret_question.question}
    column :answer
    actions
  end

  filter :answer

  form do |f|
    f.inputs "Answer" do
      f.input :secret_question_id, as: :select, collection: SecretQuestion.all.map{ |question| [question.question, question.id] }
      f.input :answer
      f.input :user_id, as: :select, collection: User.users.all.map{ |user| [user.email, user.id] }
    end
    f.actions
  end

end
