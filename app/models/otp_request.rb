class OtpRequest < ApplicationRecord
  OTP_LOWER_BOUND = 100_000
  OTP_UPPER_BOUND = 999_999
  OTP_EXPIRY_IN_MINUTES = 10
  VALID_MOBILE_NUMBER_REGEX = /\A\d{10}\z/
  OTP_LENGTH = 6
  MOBILE_NUMBER_LENGTH = 10

  validates :otp, presence: true, numericality: { only_integer: true }, length: { is: OTP_LENGTH }
  validates :mobile_number, format: { with: VALID_MOBILE_NUMBER_REGEX }, length: { is: MOBILE_NUMBER_LENGTH }
end
