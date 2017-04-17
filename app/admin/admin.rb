ActiveAdmin.register User, as: "Admin" do
  permit_params :email, :phone_number, :user_type, :keypad_number, :keypad_code, :keypad_password, :first_name, :last_name, :password, :password_confirmation
  controller do
    def scoped_collection
      super.admins
    end
  end
  index do
    selectable_column
    # id_column
    column :email
    column :first_name
    column :last_name
    column :phone_number
    actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :phone_number
      f.input :first_name
      f.input :last_name
      f.input :password
      f.input :password_confirmation
      # f.input :keypad_id
      f.input :user_type
      f.input :keypad_number
      f.input :keypad_code
      f.input :keypad_password

    end
    f.actions
  end

end
