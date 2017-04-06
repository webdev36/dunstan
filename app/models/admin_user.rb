class AdminUser < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  after_save :set_role
  attr_accessor :user_role
  USER_ROLES = [:super_admin, :employer]

  def super_admin?
    has_role? :super_admin
  end

  def employer?
    has_role? :employer
  end

  private
    def set_role
      self.add_role(user_role)
    end
end
