class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :set_keypad
  def set_keypad
    if self.keypad_number.present?
      keypad = Keypad.find_or_create_by(number:self.keypad_number, code:self.keypad_code, password:self.keypad_password)
      keypad.admin_id = self.id
      keypad.save
      self.update_attributes(keypad_id: keypad.id)
      reminder
    end
  end
  def reminder
    InviterWorker::perform_async(self.id.to_s)
  end
end
