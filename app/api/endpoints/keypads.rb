module Endpoints
  class Keypads < Grape::API

    resource :keypads do

      # Accounts API test
      # /api/v1/keypads/ping
      # results  'working now'
      get :ping do
        { :ping => 'working now' }
      end

      # On, Off Door
      # POST: /api/v1/keypads/door_lock
      #   Parameters accepted
      #     token               String *
      #     keypad_code         String *
      #     keypad_password     String *
      #     open                Boolean *
      #   Results
      #     {status: 1, data: door_status}
      params do
        requires :token,            type: String, desc: "Access token"
        requires :keypad_code,      type: String, desc: "Keypad Code"
        requires :keypad_password,  type: String, desc: "Keypad password for authenticate_keypad"
        requires :open,             type: Boolean, desc: "Door open status"
      end
      post :door_lock do
        authenticate!
        select_keypad!
        authenticate_keypad!
        keypad_params = {"OPEN": params[:open], "HOUR": DateTime.now.hour, "MIN": DateTime.now.minute,"SEC": DateTime.now.second,"PASSWORD": selected_keypad.password, "CODE": selected_keypad.code}
        # url  = "api/v1/keypad_states/open"
        # post_data(url, keypad_params)
        keypad_state = selected_keypad.keypad_state
        if keypad_state.present?
          keypad_state.update_attributes(open:params[:open])
        else
          keypad_state = KeypadState.create!(keypad_id: selected_keypad.id, open:params[:open])
        end
        {status: 1, data: {state:keypad_state.json_data}}
      end

      # Door bell
      # POST: /api/v1/keypads/door_bell
      #   Parameters accepted
      #     token               String *
      #     keypad_code         String *
      #     keypad_password     String *
      #     bell                Boolean *
      #   Results
      #     {status: 1, data: door_status}
      params do
        requires :token,            type: String, desc: "Access token"
        requires :keypad_code,      type: String, desc: "Keypad Code"
        requires :keypad_password,  type: String, desc: "Keypad password for authenticate_keypad"
        requires :bell,             type: Boolean, desc: "Door bell status"
      end
      post :door_bell do
        authenticate!
        select_keypad!
        authenticate_keypad!
        keypad_params = {"BELL": params[:bell], "HOUR": DateTime.now.hour, "MIN": DateTime.now.minute,"SEC": DateTime.now.second,"PASSWORD": selected_keypad.password, "CODE": selected_keypad.code}
        keypad_state = selected_keypad.keypad_state
        if keypad_state.present?
          keypad_state.update_attributes(bell:params[:bell])
        else
          keypad_state = KeypadState.create!(keypad_id: selected_keypad.id, bell:params[:bell])
        end
        {status: 1, data: {state:keypad_state.json_data}}
      end

      # Door block
      # POST: /api/v1/keypads/door_block
      #   Parameters accepted
      #     token               String *
      #     keypad_code         String *
      #     keypad_password     String *
      #     block               Boolean *
      #   Results
      #     {status: 1, data: door_status}
      params do
        requires :token,            type: String, desc: "Access token"
        requires :keypad_code,      type: String, desc: "Keypad Code"
        requires :keypad_password,  type: String, desc: "Keypad password for authenticate_keypad"
        requires :block,            type: Boolean, desc: "Door block status"
      end
      post :door_block do
        authenticate!
        select_keypad!
        authenticate_keypad!
        keypad_params = {"BLOCK": params[:bell], "HOUR": DateTime.now.hour, "MIN": DateTime.now.minute,"SEC": DateTime.now.second,"PASSWORD": selected_keypad.password, "CODE": selected_keypad.code}
        keypad_state = selected_keypad.keypad_state
        if keypad_state.present?
          keypad_state.update_attributes(block:params[:block])
        else
          keypad_state = KeypadState.create!(keypad_id: selected_keypad.id, block:params[:block])
        end
        {status: 1, data: {state:keypad_state.json_data}}
      end

      # Door status
      # POST: /api/v1/keypads/door_status
      #   Parameters accepted
      #     token               String *
      #     keypad_code         String *
      #     keypad_password     String *
      #     status              Boolean *
      #   Results
      #     {status: 1, data: door_status}
      params do
        requires :token,            type: String, desc: "Access token"
        requires :keypad_code,      type: String, desc: "Keypad Code"
        requires :keypad_password,  type: String, desc: "Keypad password for authenticate_keypad"
        requires :status,           type: Boolean, desc: "Door status"
      end
      post :door_status do
        authenticate!
        select_keypad!
        authenticate_keypad!
        keypad_params = {"STATUS": params[:bell], "HOUR": DateTime.now.hour, "MIN": DateTime.now.minute,"SEC": DateTime.now.second,"PASSWORD": selected_keypad.password, "CODE": selected_keypad.code}
        keypad_state = selected_keypad.keypad_state
        if keypad_state.present?
          keypad_state.update_attributes(status:params[:status])
        else
          keypad_state = KeypadState.create!(keypad_id: selected_keypad.id, status:params[:status])
        end
        {status: 1, data: {state:keypad_state.json_data}}
      end

      # Get door picture
      # GET: /api/v1/keypads/door_picture
      #   Parameters accepted
      #     token               String *
      #     keypad_code         String *
      #     keypad_password     String *
      #     view                Boolean *
      #   Results
      #     {status: 1, data: door_status}
      params do
        requires :token,            type: String, desc: "Access token"
        requires :keypad_code,      type: String, desc: "Keypad Code"
        requires :keypad_password,  type: String, desc: "Keypad password for authenticate_keypad"
        requires :view,             type: Boolean, desc: "Door view status"
      end
      get :door_picture do
        authenticate!
        select_keypad!
        authenticate_keypad!
        keypad_params = {"VIEW": params[:view], "HOUR": DateTime.now.hour, "MIN": DateTime.now.minute,"SEC": DateTime.now.second,"PASSWORD": selected_keypad.password, "CODE": selected_keypad.code}
        keypad_state = selected_keypad.keypad_state
        {status:1, data:{door_img: 'door/online-loans.jpg'}}
      end



    end # resource
  end # class
end # module
