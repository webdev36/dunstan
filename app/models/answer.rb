class Answer < ApplicationRecord
  belongs_to :secret_question
  belongs_to :user
end
