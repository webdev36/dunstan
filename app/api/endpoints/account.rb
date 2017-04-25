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
        selected_keypad = Keypad.find_by(code:params[:keypad_code])
        user = User.find_by(email: params[:email])
        unless selected_keypad.present?
          return {status: 0, data: "Can not find door using this keypad_code #{params[:keypad_code]}"}
        end

        if user.present?
          selected_keypad.add_user(user).update_attributes(door_name: params[:door_name])
          user.generate_token
          {status: 1, data: {token: user.token}}
          # {status: 0, data: "This email '#{params[:email]}' is already exists."}
        else
          user = User.new(email: params[:email], phone_number: params[:phone_number], password: params[:password], password_confirmation: params[:password])
          if user.save
            selected_keypad.add_user(user).update_attributes(door_name: params[:door_name])
            user.generate_token
            {status: 1, data: {token: user.token}}
          else
            {status: 0, data: user.errors.messages}
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
      #   old_email               String *
      #   new_email               String *
      # Results
      #     {status: 1, data: user_info}
      params do
        requires :token,      type: String, desc: "Access token"
        requires :old_email,  type: String, desc: "current email"
        requires :new_email,  type: String, desc: "new email"
      end
      post :update_email do
        authenticate!
        if current_user.email == params[:old_email]
          current_user.update_attributes(email: params[:new_email])
          {status: 1, data: "Updated email successfully"}
        else
          {status: 0, data: "Can't find old email"}
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


      # Check Answer for security question
      # POST: /api/v1/account/check_security_answer
      #   Parameters accepted
      #     token               String *
      #     answers             JSON * , ex: [{question_id:1, answer:'yes'}, {...}]
      #   Results
      #     {status: 1, data: answer_id}
      params do
        requires :token,              type: String, desc: "Acess token"
        requires :answers,            type: Array
      end
      post :check_security_answer do
        authenticate!
        if params[:answers].class == String
          answers = JSON.parse(params[:answers])
        else
          answers = params[:answers]
        end
        answers.each do |item|
          answer = Answer.find_by(user_id:current_user.id,secret_question_id:item['question_id'])
          unless answer.answer == item['answer']
            return {status: 0, data: "Check your answers again"}
          end
        end
        {status: 1, data: "Checked your secret questions and answers"}
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
        keypads = current_user.user_keypads.map{|pad| pad.json_data}
        {status: 1, data: keypads}
      end

      # Get admin doors
      # GET: /api/v1/account/admin_doors
      #   Parameters accepted
      #     token               String *
      #   Results
      #     {status: 1, data: [{id,number,code,stat},{...}}]}
      params do
        requires :token,            type: String, desc: "Access Token"
      end
      get :admin_doors do
        authenticate!
        keypads = current_user.admin_keypads.map{|pad| pad.json_data}
        {status: 1, data: keypads}
      end

      # Get Users
      # GET: /api/v1/account/users
      #   Parameters accepted
      #     token               String *
      #     keypad_code         String *
      #   Results
      #     {status: 1, data: [{id,number,code,stat},{...}}]}
      params do
        requires :token,            type: String, desc: "Access Token"
        requires :keypad_code,      type: String, desc: "keypad code"
      end
      get :users do
        authenticate!
        select_keypad!
        users = selected_keypad.users.map{|u| u.json_data}
        {status: 1, data: users}
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


      # Delete User
      # POST: /api/v1/account/delete_user
      #   Parameters accepted
      #     token               String *
      #     keypad_code         String *
      #     phone_number        String *
      #   Results
      #     {status: 1, data: [{id,number,code,stat},{...}}]}
      params do
        requires :token,            type: String, desc: "Access Token"
        requires :keypad_code,      type: String, desc: "keypad code"
        requires :phone_number,     type: String, desc: "user phone number"
      end
      post :delete_user do
        authenticate!
        select_keypad!
        user = User.find_by(phone_number:params[:phone_number])
        user = selected_keypad.user_keypads.find_by(user_id:user.id)
        user.destroy if user.present?
        {status: 1, data: "deleted user"}
      end

      # Get door status
      # GET: /api/v1/accounts/door_status
      #   Parameters accepted
      #     token               String *
      #     keypad_code         String *
      #   Results
      #     {status: 1, data: door_status}
      params do
        requires :token,            type: String, desc: "Access token"
        requires :keypad_code,      type: String, desc: "Keypad Code"
      end
      get :door_status do
        authenticate!
        select_keypad!
        {status: 1, data: selected_keypad.status.nil? ? "false" : selected_keypad.status}
      end


      # Delete admin door
      # POST: /api/v1/account/delete_doors
      #   Parameters accepted
      #     token               String *
      #     keypad_codes        String *
      #   Results
      #     {status: 1, data: "Deleted doors"}
      params do
        requires :token,            type: String, desc: "Access Token"
        requires :keypad_codes,     type: String, desc: "Door codes"
      end
      post :delete_doors do
        authenticate!
        if params[:answers].class == String
          codes = JSON.parse(params[:keypad_codes])
        else
          codes = params[:keypad_codes]
        end
        codes.each do |keypad_code|
          keypad = current_user.admin_keypads.find_by(code:keypad_code)
          keypad.destroy if keypad.present?
        end
        {status: 1, data: "Deleted doors"}
      end



    end
  end
end
