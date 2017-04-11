module Endpoints
  class Account < Grape::API

    resource :account do

      # Accounts API test
      # /api/v1/account/ping
      # results  'working now'
      get :ping do
        { :ping => 'working now' }
      end

      # Sign up
      # POST: /api/v1/accounts/sign_up
      #   Parameters accepted
      #   email               String *
      #   phone_number        String *
      #   keypad_code         String *
      #   password            String *
      # Results
      #     {status: 1, data: user_info}
      post :sign_up do
        user = User.find_by(email: params[:email])
        if user.present?
          {status: 0, data: "This email '#{params[:email]}' is already exists."}
        else
          keypad = Keypad.find_by(code:params[:keypad_code])
          if keypad.present?
            user = User.new(email: params[:email], phone_number: params[:phone_number], keypad_id: keypad.id, password: params[:password], password_confirmation: params[:password])
            if user.save
              {status: 1, data: "Sent notification to #{params[:phone_number]}"}
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
      post :sign_in do
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
      post :update_email do
        user  = User.find_by_token(params[:token])
        if user.present? and user.valid_password? params['password']
          if user.email == params[:old_email]
            user.update_attributes(email: params[:new_email])
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
      post :update_password do
        user  = User.find_by_token(params[:token])
        if user.present?
          if user.valid_password? params[:old_password]
            user.update_attributes(password: params[:new_password], password_confirmation:params[:new_password])
            {status: 1, data: "Updated password successfully"}
          else
            {status: 0, data: "Dose not valid current password"}
          end
        else
          {status: 0, data: "Please signin again"}
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
      #     question_id         Integer *
      #     answer              String *
      #   Results
      #     {status: 1, data: answer_id}
      post :security_answer do
        question = SecretQuestion.find_by(id:params[:question_id])
        user  = User.find_by_token(params[:token])
        if question.present? and user.present?
          answer = Answer.create(user_id:user.id,secret_question_id:question.id, answer:params[:answer])
          {status: 1, data: {answer_id: answer.id}}
        else
          {status: 0, data: "Can't find question"}
        end
      end


      # Get doors
      # GET: /api/v1/account/doors
      #   Parameters accepted
      #     token               String *
      #   Results
      #     {status: 1, data: [{id,number,code,stat},{...}}]}
      get :doors do
        user  = User.find_by_token(params[:token])
        if user.present?
          keypads = user.keypads.map{|pad| pad.json_data}
          {status: 1, data: keypads}
        else
          {status: 0, data: "Please signin again"}
        end
      end


    end
  end
end
