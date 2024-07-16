require 'rails_helper'

RSpec.describe OtpRequest, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:mobile_number) }
    it { is_expected.to validate_length_of(:mobile_number).is_equal_to(OtpRequest::MOBILE_NUMBER_LENGTH) }
    it { is_expected.to allow_value('9828475892').for(:mobile_number) }
    it { is_expected.not_to allow_value('9828475').for(:mobile_number) }
    it { is_expected.not_to allow_value('9828475892000').for(:mobile_number) }
    it { is_expected.to validate_presence_of(:otp) }
    it { is_expected.to validate_numericality_of(:otp).only_integer }
    it { is_expected.to validate_length_of(:otp).is_equal_to(OtpRequest::OTP_LENGTH) }
  end

  describe '#expired' do
    it 'should return true if the otp is expired' do
      otp_request = build(:otp_request, mobile_number: '9898987987', otp: '678678', expire_at: 10.minutes.ago)
      expect(otp_request).to be_expired
    end

    it 'should return false if the otp is not expired' do
      otp_request = build(:otp_request, mobile_number: '9898987987', otp: '678678', expire_at: 10.minutes.from_now)
      expect(otp_request).not_to be_expired
    end
  end
end
