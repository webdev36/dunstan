ActiveAdmin.register User, as: "User" do
  permit_params :email, :first_name, :last_name, :phone_number, :user_type, :keypad_id
  controller do
    def scoped_collection
      super.users
    end
  end
  index do
    selectable_column
    # id_column
    column :email
    column :first_name
    column :last_name
    column :keypad_id
    actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :phone_number
      # f.input :password
      # f.input :password_confirmation
      f.input :keypad_id, as: :select, collection: Keypad.all.map{|keypad| [keypad.number, keypad.id]}
      f.input :user_type
      # f.input :keypad_number
      # f.input :keypad_code
      # f.input :keypad_password
    end
    f.actions
  end

end
