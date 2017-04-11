= DUNSTAN API GUIDE

== Accounts API

==== Sign up
    POST: /api/v1/account/sign_up

    parameters accepted
      email               String *
      phone_number        String *
      keypad_id           Integer *
      password            String *

      curl \
        -F "email=tester2@email.com" \
        -F "password=tester2" \
        -F "phone_number=+8613050387411" \
        -F "keypad_id=6" \
        http://localhost:5000/api/v1/account/sign_up
      results:
      {"status": 1, "data":"sent notification to the phone_number"}

  ==== Sign in
      POST: /api/v1/account/sign_in

      parameters accepted
        phone_number        String *
        password            String *

        curl \
          -F "password=tester2" \
          -F "phone_number=+8613050387411" \
          http://localhost:5000/api/v1/account/sign_in
        results:
        {"status": 1, "data":{token: string}}

  ==== Update Email
      POST: /api/v1/account/update_email

      parameters accepted
        token                   String *
        password                String *
        old_email               String *
        new_email               String *

        curl \
          -F "password=tester1" \
          -F "token=7GbxtN9-NDcLARjE30Jfvamh9iP5NbvykhTfoSBAAZU" \
          -F "old_email=tester1@email.com" \
          -F "new_email=test1@email.com" \
          http://localhost:5000/api/v1/account/update_email
        results:
        {status: 1, data: "Updated email successfully"}

  ==== Update Password
      POST: /api/v1/account/update_email

      parameters accepted
        token               String *
        old_password        String *
        new_password        String *

        curl \
          -F "token=7GbxtN9-NDcLARjE30Jfvamh9iP5NbvykhTfoSBAAZU" \
          -F "old_password=tester1" \
          -F "new_password=test1" \
          http://localhost:5000/api/v1/account/update_password
        results:
        {status: 1, data: "Updated password successfully"}

  ==== Get all security questions
    GET: /api/v1/account/security_questions
      Parameters accepted
      Results
        {status: 1, data: [{id, question}, {...}]}

  ==== security_answer
      POST: /api/v1/account/security_answer

      parameters accepted
        token               String *
        question_id         Integer *
        answer              String *

        curl \
          -F "token=7GbxtN9-NDcLARjE30Jfvamh9iP5NbvykhTfoSBAAZU" \
          -F "question_id=2" \
          -F "answer=Rasemeup" \
          http://localhost:5000/api/v1/account/security_answer
        results:
        {status: 1, data: {answer_id: answer.id}}
  ==== Get doors
      GET: /api/v1/account/doors
        Parameters accepted
          token               String *
        Results
          {status: 1, data: [{id,number,code,stat},{...}}]}


== Keypad API
