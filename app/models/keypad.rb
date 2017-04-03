class Keypad < ApplicationRecord
  belongs_to :admin, :class_name => "User", foreign_key: 'admin_id'
  has_many :users, inverse_of: :keypad

  validates :admin_id, presence: true
  validates :number, presence: true
  validates :code, presence: true

  after_create :sent_sms

  def sent_sms
    InviterWorker::perform_async(self.admin_id.to_s)
  end
end
