module Endpoints
  class Keypads < Grape::API

    resource :keypads do

      # Accounts API test
      # /api/v1/keypads/ping
      # results  'working now'
      get :ping do
        { :ping => 'working now' }
      end

      # on, off door
      # POST: /api/v1/keypads/door_lock
      #   Parameters accepted
      #     token               String *
      #     keypad_id           Integer *
      #     open                Boolean *
      #   Results
      #     {status: 1, data: door_status}
      post :door_lock do
        user  = User.find_by_token(params[:token])
        if user.present?
          keypads = user.keypads.map{|pad| pad.json_data}
          {status: 1, data: keypads}
        else
          {status: 0, data: "Please signin again"}
        end
      end

      # Door call
      # GET: /api/v1/keypads/door_call
      #   Parameters accepted
      #     token               String *
      #     keypad_id           Integer *
      #   Results
      #     {status: 1, data: door_status}
      get :door_call do
        user  = User.find_by_token(params[:token])
        if user.present?
          keypads = user.keypads.map{|pad| pad.json_data}
          {status: 1, data: keypads}
        else
          {status: 0, data: "Please signin again"}
        end
      end

      # Door bell
      # GET: /api/v1/keypads/door_bell
      #   Parameters accepted
      #     token               String *
      #     keypad_id           Integer *
      #   Results
      #     {status: 1, data: door_status}
      get :door_bell do
        user  = User.find_by_token(params[:token])
        if user.present?
          keypads = user.keypads.map{|pad| pad.json_data}
          {status: 1, data: keypads}
        else
          {status: 0, data: "Please signin again"}
        end
      end

      # Get door picture
      # GET: /api/v1/keypads/door_picture
      #   Parameters accepted
      #     token               String *
      #     keypad_id           Integer *
      #   Results
      #     {status: 1, data: door_status}
      get :door_picture do
        user  = User.find_by_token(params[:token])
        if user.present?
          keypads = user.keypads.map{|pad| pad.json_data}
          {status: 1, data: keypads}
        else
          {status: 0, data: "Please signin again"}
        end
      end



    end # resource
  end # class
end # module
