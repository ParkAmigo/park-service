class User < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t('is_invalid') }, on: :update
end
