class KeypadStatesController < ApplicationController
  before_action :keypad
  def create
  end

  def update
  end

  # post :open
  def open
  end
  # post :ring
  def ring
  end
  # post :block
  def block
  end
  # get :status
  def status
  end
  # get :view
  def view
  end
  # get :call
  def call
  end

  def keypad
    @keypad = Keypad.find_by(code: params[:code])
  end
end
