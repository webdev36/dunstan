ActiveAdmin.register Keypad, as: "Keypad" do
  permit_params :number, :password, :code, :status, :admin_id, :sim_number

  controller do

  end

  index do
    selectable_column
    # id_column
    column :sim_number
    column :number
    column :password
    column :code
    column :status
    column :admin_id
    actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :sim_number
      f.input :number
      f.input :password
      f.input :code
      f.input :status
      f.input :admin_id, as: :select, collection: User.admins.map { |admin| [admin.phone_number, admin.id] }
    end
    f.actions
  end

end
