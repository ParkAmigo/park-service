class User < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: :is_invalid }, if: -> { email.present? }
end
