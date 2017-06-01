class Keypad < ApplicationRecord
  belongs_to :admin, :class_name => "User", foreign_key: 'admin_id'

  has_many :user_keypads, dependent: :destroy
  has_many :users, through: :user_keypads

  has_one :keypad_state, dependent: :destroy
  has_many :keypad_histories, dependent: :destroy

  validates :admin_id, presence: true
  validates :number, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  # after_create :send_sms

  def add_user user
    user_keypad = UserKeypad.where(user_id:user.id, keypad_id:self.id).first
    if user_keypad.present?
      user_keypad
    else
      UserKeypad.create!(user_id:user.id,keypad_id:self.id)
    end
  end

  def json_data
    {id:id, number:number, password: password, code:code, status: status.nil? ? "false" : status, sim_number: sim_number.nil? ? "" : sim_number,}
  end

  # def send_sms
  #   KeypadWorker::perform_async(self.admin_id.to_s, self.keypad_id)
  # end
end
