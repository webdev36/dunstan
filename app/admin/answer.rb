ActiveAdmin.register Answer, as: "Answer" do
  permit_params :question
  # controller do
  #   def scoped_collection
  #     super.users
  #   end
  # end
  index do
    selectable_column
    # id_column
    column :user_id
    column :secret_question_id
    column :answer
    actions
  end

  filter :answer

  form do |f|
    f.inputs "Admin Details" do
      f.input :secret_question_id, as: :select, collection: SecretQuestion.all.map{ |question| [question.question, question.id] }
      f.input :answer
      f.input :user_id, as: :select, collection: User.users.all.map{ |user| [user.email, user.id] }
    end
    f.actions
  end

end
