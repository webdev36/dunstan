class KeypadHistory < ApplicationRecord
  belongs_to :user
  belongs_to :keypad
end
