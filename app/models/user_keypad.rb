class UserKeypad < ApplicationRecord
  belongs_to :user
  belongs_to :keypad
  after_create :send_sms

  def send_sms
    InviterWorker::perform_async(self.user_id, self.keypad_id)
  end
  def json_data
    { id: keypad.id,
      number: keypad.number,
      sim_number: keypad.sim_number.present? ? keypad.sim_number : "",
      code: keypad.code,
      status: keypad.status.nil? ? "false" : keypad.status,
      name: self.door_name.nil? ? "" : self.door_name,
      password: keypad.password }
  end
end
