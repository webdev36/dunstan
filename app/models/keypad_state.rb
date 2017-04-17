# == Schema Information
#
# Table name: users
#
# id                :integer
# keypad_id         :string
# open              :string
# bell              :string
# error             :string
# power             :string
#
# created_at        :string
# updated_at        :string

class KeypadState < ApplicationRecord
  belongs_to :keypad

  def json_data
    {open:open, bell:bell, error:error, power:power, status:status}
  end
end
