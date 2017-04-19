module Endpoints
  class Account < Grape::API

    resource :account do

      # Accounts API test
      # /api/v1/account/ping
      # results  'working now'
      params do
        requires :token, type: String, desc: "Access token"
      end
      get :ping do
        authenticate!
        { :ping => 'working now', user: current_user.email }
      end

      # Sign up
      # POST: /api/v1/accounts/sign_up
      #   Parameters accepted
      #   door_name           String *
      #   email               String *
      #   phone_number        String *
      #   keypad_code         String *
      #   password            String *
      # Results
      #     {status: 1, data: user_info}
      params do
        requires :email,            type: String, desc: "User email"
        requires :password,         type: String, desc: "User password"
        requires :phone_number,     type: String, desc: "User phone number"
        requires :keypad_code,      type: String, desc: "Keypad code"
        requires :door_name,        type: String, desc: "Door Name"
      end
      post :sign_up do
        valid_phone_number!
        user = User.find_by(email: params[:email])
        if user.present?
          {status: 0, data: "This email '#{params[:email]}' is already exists."}
        else
          keypad = Keypad.find_by(code:params[:keypad_code])
          if keypad.present?
            user = User.new(email: params[:email], phone_number: params[:phone_number], password: params[:password], password_confirmation: params[:password])
            if user.save
              keypad.add_user(user).update_attributes(door_name: params[:door_name])
              user.generate_token
              {status: 1, data: {token: user.token}}
            else
              {status: 0, data: user.errors.messages}
            end
          else
            {status: 0, data: "Can't find keypad"}
          end
        end
      end

      # Sign in
      # POST: /api/v1/account/sign_in
      #   Parameters accepted
      #   phone_number        String *
      #   password            String *
      # Results
      #     {status: 1, data: {token:string}}
      params do
        requires :phone_number,   type: String, desc: "user phone number"
        requires :password,       type: String, desc: "user password"
      end
      post :sign_in do
        valid_phone_number!
        user = User.find_by(phone_number:params[:phone_number])
        if user.present?
          user.generate_token
          {status: 1, data: {token:user.token}}
        else
          {status: 0, data: "Can't find this user"}
        end
      end

      # Update User Information
      # POST: /api/v1/account/update_email
      #   Parameters accepted
      #   token                   String *
      #   password                String *
      #   old_email               String *
      #   new_email               String *
      # Results
      #     {status: 1, data: user_info}
      params do
        requires :token,      type: String, desc: "Access token"
        requires :password,   type: String, desc: "current password"
        requires :old_email,  type: String, desc: "current email"
        requires :new_email,  type: String, desc: "new email"
      end
      post :update_email do
        authenticate!
        if current_user.valid_password? params['password']
          if current_user.email == params[:old_email]
            current_user.update_attributes(email: params[:new_email])
            {status: 1, data: "Updated email successfully"}
          else
            {status: 0, data: "Can't find old email"}
          end
        else
          {status: 0, data: "Please signin again"}
        end
      end

      # Update User Information
      # POST: /api/v1/account/update_password
      #   Parameters accepted
      #   token               String *
      #   old_password        String *
      #   new_password        String *
      # Results
      #     {status: 1, data: user_info}
      params do
        requires :token,        type: String, desc: "Access token"
        requires :old_password, type: String, desc: "current password"
        requires :new_password, type: String, desc: "new password"
      end
      post :update_password do
        authenticate!
        if current_user.valid_password? params[:old_password]
          current_user.update_attributes(password: params[:new_password], password_confirmation:params[:new_password])
          {status: 1, data: "Updated password successfully"}
        else
          {status: 0, data: "Dose not valid current password"}
        end

      end

      # Get all security questions
      # GET: /api/v1/account/security_questions
      #   Parameters accepted
      #   Results
      #     {status: 1, data: {id, question}}
      get :security_questions do
        questions = SecretQuestion.all.map{|qst| {id:qst.id, question:qst.question}}
        {status: 1, data: questions}
      end

      # Answer for security question
      # POST: /api/v1/account/security_answer
      #   Parameters accepted
      #     token               String *
      #     answers             JSON * , ex: [{question_id:1, answer:'yes'}, {...}]
      #   Results
      #     {status: 1, data: answer_id}
      params do
        requires :token,              type: String, desc: "Acess token"
        requires :answers,            type: Array
      end
      post :security_answer do
        authenticate!
        if params[:answers].class == String
          answers = JSON.parse(params[:answers])
        else
          answers = params[:answers]
        end
        answers.each do |item|
          question = SecretQuestion.find_by(id:item['question_id'])
          if question.present?
            answer = Answer.find_or_create_by(user_id:current_user.id,secret_question_id:question.id).update_attributes(answer:item['answer'])
          end
        end
        {status: 1, data: "Answered"}
      end


      # Get doors
      # GET: /api/v1/account/doors
      #   Parameters accepted
      #     token               String *
      #   Results
      #     {status: 1, data: [{id,number,code,stat},{...}}]}
      params do
        requires :token,            type: String, desc: "Access Token"
      end
      get :doors do
        authenticate!
        keypads = current_user.keypads.map{|pad| pad.json_data}
        {status: 1, data: keypads}
      end

      # Invite user
      # POST: /api/v1/account/invite
      #   Parameters accepted
      #     token               String *
      #     phone_number        String *
      #     keypad_code         String *
      # Results
      #     {status: 1, data: {token:string}}
      params do
        requires :token,            type: String, desc: "Access token"
        requires :phone_number,     type: String, desc: "to invite user's phone_number"
        requires :keypad_code,      type: String, desc: "Keypad code"
      end
      post :invite do
        authenticate!
        select_keypad!
        valid_phone_number!
        user = User.find_by(phone_number: params[:phone_number])
        if user.present?
          if selected_keypad.user_keypads.find_by(user_id:user.id).present?
            {status: 0, data: {status: "Already exists on this keypad"}}
          else
            selected_keypad.add_user(user)
            {status: 1, data: {status:"Invited user to keypad #{selected_keypad.code}"}}
          end
        else
          KeypadWorker::perform_async(params[:phone_number], params[:keypad_code])
          {status: 1, data: {status:"Invited user to keypad #{selected_keypad.code}"}}
        end

      end

    end
  end
end
