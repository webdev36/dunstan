# == Schema Information
#
# Table name: users
#
# id                :integer
# email             :string
# first_name        :string
# last_name         :string
# user_type         :integer
# avatar            :string
# invited_at        :datetime
# invite_status     :integer
# phone_number      :string
# keypad_id         :integer
# keypad_number     :string
# keypad_code       :string
# keypad_password   :string
#
# invited_at
#
#
# created_at        :string
# updated_at        :string

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  # attr_accessor :password, :password_confirmation

  # belongs_to :keypad, inverse_of: :users
  # has_many :keypads, class_name: "Keypad", foreign_key: 'admin_id'

  has_many :user_keypads
  has_many :keypads, through: :user_keypads

  validates :phone_number, presence: true, uniqueness: true
  validates :keypad_id, presence: true, unless: :is_admin

  scope :admins, -> { where( user_type: 'admin') }
  scope :users, -> { where( user_type: 'user') }

  # attr_accessor :skip_password_validation
  after_create :set_keypad

  enum user_type: [:user, :admin]
  enum invite_status: [:pending, :accept, :decline]

  def is_admin
    user_type == "admin"
  end

  def json_data
    {id: id, first_name: first_name, last_name: last_name, phone_number: phone_number}
  end

  def generate_token
    begin
      self.token = SecureRandom.urlsafe_base64(32)
    end while User.exists?(token: self.token)
    self.save
  end

  def self.find_by_token(token)
    User.where(:token=>token).first
  end

  def set_keypad
    if self.keypad_number.present?
      keypad = Keypad.find_or_create_by(number:self.keypad_number, code:self.keypad_code, password:self.keypad_password)
      keypad.admin_id = self.id
      keypad.save
      UserKeypad.create!(user_id:self.id, keypad_id:keypad.id)
    elsif self.keypad_id.present?
      UserKeypad.create!(user_id:self.id, keypad_id:self.keypad_id)
      InviterWorker::perform_async(self.id, self.keypad_id)
    end
  end
end
