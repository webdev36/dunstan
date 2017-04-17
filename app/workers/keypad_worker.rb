class KeypadWorker
  include Sidekiq::Worker

  def perform(phone_number, keypad_code)
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    reminder = "#{keypad_code} is your Door Code"
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => phone_number,
      :body => reminder,
    )
  end
end
