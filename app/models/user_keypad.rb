class UserKeypad < ApplicationRecord
  belongs_to :user
  belongs_to :keypad
  after_create :send_sms

  def send_sms
    InviterWorker::perform_async(self.user_id, self.keypad_id)
  end
end
