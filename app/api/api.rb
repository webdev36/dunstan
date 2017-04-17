class API < Grape::API
  prefix 'api'
  version 'v1'
  format :json

  helpers do
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end

    def current_user
      if params[:token].present?
        @current_user = User.find_by_token(params[:token])
      else
        false
      end
    end

    def authenticate_keypad!
      error!('Unauthorized keypad, Please check your keypad password.', 401) unless selected_keypad.password == params[:keypad_password]
    end
    def select_keypad!
        error!('Can not select keypad, please confirm the keypad code again', 401) unless selected_keypad
    end
    def selected_keypad
      if params[:keypad_code].present?
        @selected_keypad = current_user.keypads.find_by(code: params[:keypad_code])
      else
        false
      end
    end

    def valid_phone_number!
      error!('Please check your phone number, this phone number is invalid.', 401) unless Phonelib.valid?(params[:phone_number])      
    end

    require 'rest-client'
    def post_data(uri, data)
      # host = Rails.application.secrets.api_host
      host = "http://127.0.0.1:5000/"
      response_data = {}
      p ">>>>>#{host+uri}"
      RestClient.post(host+uri, data.to_json, :content_type => :json, :accept => :json){ |response, request, result, &block|
        case response.code
        when 200
          p "It worked !"
          response_data = JSON.parse(response.body)
        when 400
          p "400 BAD request HTTP error code"
          response_data = JSON.parse(response.body)
          p response.body
        when 403
          p response.body
        when 404
          p "404 BAD request HTTP error code"
          response_data = JSON.parse(response.body)
          p response.body
        when 500
          p "500 Internal Server Error"
          response_data = JSON.parse(response.body)
          p response.body
        else
          p "post response.code>>>>>>>#{response.code}"
          p response.body
        end
      }
      response_data
    end

  end

  # load remaining API endpoints
  mount Endpoints::Account
  mount Endpoints::Keypads
  mount Endpoints::KeypadStates
end
