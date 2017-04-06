ActiveAdmin.register SecretQuestion, as: "SecretQuestion" do
  permit_params :question
  # controller do
  #   def scoped_collection
  #     super.users
  #   end
  # end
  index do
    selectable_column
    # id_column
    column :question
    actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :question
    end
    f.actions
  end

end
