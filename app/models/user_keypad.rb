class UserKeypad < ApplicationRecord
  belongs_to :user
  belongs_to :keypad
end
