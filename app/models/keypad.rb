class Keypad < ApplicationRecord
  belongs_to :admin, :class_name => "User", foreign_key: 'admin_id'
  has_many :user_keypads
  has_many :users, through: :user_keypads

  validates :admin_id, presence: true
  validates :number, presence: true
  validates :code, presence: true

  after_create :sent_sms

  def json_data
    {id:id, number:number, code:code, status:status}
  end
  
  def sent_sms
    KeypadWorker::perform_async(self.admin_id.to_s, self.keypad_id)
  end
end
