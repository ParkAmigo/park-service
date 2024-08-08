class Address < ApplicationRecord
  VALID_PINCODE_REGEX = /\A[1-9][0-9]{5}\z/

  belongs_to :parking_lot
  validates :address_line_first, :address_line_second, :pin_code, presence: true
  validates :pin_code,
            format: { with: VALID_PINCODE_REGEX,
                      message: I18n.t('activerecord.errors.messages.must_be_a_valid_indian_pin_code') }
end
