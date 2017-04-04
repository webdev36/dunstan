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
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :password, :password_confirmation

  belongs_to :keypad, inverse_of: :users
  has_many :keypads, class_name: "Keypad", foreign_key: 'admin_id'

  validates :phone_number, presence: true, uniqueness: true
  validates :keypad_id, presence: true, unless: :is_admin

  scope :admins, -> { where( user_type: 'admin') }
  scope :users, -> { where( user_type: 'user') }

  attr_accessor :skip_password_validation
  after_create :set_keypad

  enum user_type: [:user, :admin]
  enum invite_status: [:pending, :accept, :decline]

  def is_admin
    user_type == "admin"
  end

  def set_keypad
    if self.keypad_number.present?
      keypad = Keypad.find_or_create_by(number:self.keypad_number, code:self.keypad_code, password:self.keypad_password)
      keypad.admin_id = self.id
      keypad.save
      self.update_attributes(keypad_id: keypad.id)
    end
  end
end
