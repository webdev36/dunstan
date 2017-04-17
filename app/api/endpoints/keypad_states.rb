module Endpoints
  class KeypadStates < Grape::API

    resource :keypad_states do

      # Accounts API test
      # /api/v1/keypad_states/ping
      # results  'working now'
      get :ping do
        { :ping => 'working now' }
      end


      # locks/unlocks the door
      # POST /api/v1/keypad_states/open
      # PARAMS:
      #   keypad_code:      string
      #   keypad_password:  string
      #   OPEN:             boolean
      # RESULT:
      #
      params do
        requires :CODE,  type: String, desc: "Keypad Code"
        requires :PASSWORD,  type: String, desc: "Keypad Code"
        requires :OPEN, type: Boolean, desc: "Door status"
      end
      post :open do
        keypad = Keypad.find_by(code:params[:CODE])
        keypad_state = keypad.keypad_state
        if keypad_state.present?
          keypad_state.update_attributes(open:params[:OPEN])
        else
          keypad_state = KeypadState.create!(keypad_id: keypad.id, open:params[:OPEN])
        end
        {status: 1, data: {state_id:keypad_state.id}}
      end


      params do
        requires :keypad_code,  type: String, desc: "Keypad Code"
        requires :keypad_password,  type: String, desc: "Keypad Code"
        requires :BELL, type: Boolean, desc: "Bell status"
      end
      post :bell do
        keypad = Keypad.find_by(code:params[:CODE])
        keypad_state = keypad.keypad_state
        if keypad_state.present?
          keypad_state.update_attributes(bell:params[:BELL])
        else
          keypad_state = KeypadState.create!(keypad_id: keypad.id, open:params[:BELL])
        end
      end



    end # resource
  end # class
end # module


# RING – rings the door bell
# {"RING": "true", "HOUR":"10", "MIN":"30","SEC":"15","PASSWORD":"passw*rd"}
# ACTION: the door bell is rung and a STATUS message is returned.
#
# BLOCK – disables all remote access. This can only be reversed using the internal key-pad.
# {"BLOCK": "true", "HOUR":"10", "MIN":"30","SEC":"15","PASSWORD":"passw*rd"}
# ACTION: the door will not accept any further commands except for STATUS.
#
# STATUS – request the current door status
# {"STATUS": "true", "HOUR":"10", "MIN":"30","SEC":"15","PASSWORD":"passw*rd"}
# ACTION: STATUS message is returned.
#
# VIEW - Request the door lock to send a JPG image from its camera.
# {"VIEW": "true", "HOUR":"10", "MIN":"30","SEC":"15","PASSWORD":"passw*rd"}
# ACTION: the door operates its camera and sends a JPEG image to the server. Format TBD.
#
# CALL - Initiate a voice link between the door lock and the calling number.
