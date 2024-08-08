class User < ApplicationRecord
  VALID_MOBILE_NUMBER_REGEX = /\A\d{10}\z/
  MOBILE_NUMBER_LENGTH = 10

  validates :mobile_number, presence: true, format: { with: VALID_MOBILE_NUMBER_REGEX },
                            length: { is: MOBILE_NUMBER_LENGTH }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: :is_invalid }, if: -> { email.present? }
  has_many :parking_lots, foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy
end
