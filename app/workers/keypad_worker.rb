class KeypadWorker
  include Sidekiq::Worker

  def perform(phone_number, keypad_code,password)
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    reminder = "Invited you to #{keypad_code}. #{keypad_code} is your Door Code and App Password is #{password}"
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => phone_number,
      :body => reminder,
    )
  end
end
