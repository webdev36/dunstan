class InviterWorker
  include Sidekiq::Worker

  def perform(user_id, keypad_id)
    user = User.find(user_id.to_i)
    keypad = Keypad.find(keypad_id)
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    reminder = "#{keypad.code} is your Door Code"
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => user.phone_number,
      :body => reminder,
    )
  end
end
