require 'rails_helper'

RSpec.describe OtpRequest, type: :model do
  describe 'Validations' do
    let(:valid_mobile_number) { '9948394583' }
    let(:valid_otp) { '982227' }

    context 'When mobile number and otp are of exactly 10 and 6 digits respectively' do
      it 'should be valid' do
        otp = build(:otp_request, mobile_number: valid_mobile_number, otp: valid_otp, expire_at: 10.minutes.from_now)

        expect(otp).to be_valid
      end
    end

    context 'When mobile number length is more than 10 digits' do
      it 'should not be valid' do
        invalid_mobile_number = '9948394583000'
        otp = build(:otp_request, mobile_number: invalid_mobile_number, otp: valid_otp, expire_at: 10.minutes.from_now)

        expect(otp).not_to be_valid
        expect(otp.errors.messages).to have_key(:mobile_number)
      end
    end

    context 'When mobile number length is less than 10 digits' do
      it 'should not be valid' do
        invalid_mobile_number = '9948394'
        otp = build(:otp_request, mobile_number: invalid_mobile_number, otp: valid_otp, expire_at: 10.minutes.from_now)

        expect(otp).not_to be_valid
        expect(otp.errors.messages).to have_key(:mobile_number)
      end
    end

    context 'When mobile number is having non numeric characters' do
      it 'should not be valid' do
        invalid_mobile_number = '99483946A0'
        otp = build(:otp_request, mobile_number: invalid_mobile_number, otp: valid_otp, expire_at: 10.minutes.from_now)

        expect(otp).not_to be_valid
        expect(otp.errors.messages).to have_key(:mobile_number)
      end
    end

    context 'When mobile number is not present' do
      it 'should not be valid' do
        otp = build(:otp_request, mobile_number: nil, otp: valid_otp, expire_at: 10.minutes.from_now)

        expect(otp).not_to be_valid
        expect(otp.errors.messages).to have_key(:mobile_number)
      end
    end

    context 'When otp is of length less than 6 digits' do
      it 'should not be valid' do
        invalid_otp = '3000'
        otp = build(:otp_request, mobile_number: valid_mobile_number, otp: invalid_otp, expire_at: 10.minutes.from_now)

        expect(otp).not_to be_valid
        expect(otp.errors.messages).to have_key(:otp)
      end
    end

    context 'When otp is of length greater than 6 digits' do
      it 'should not be valid' do
        invalid_otp = '300099282'
        otp = build(:otp_request, mobile_number: valid_mobile_number, otp: invalid_otp, expire_at: 10.minutes.from_now)

        expect(otp).not_to be_valid
        expect(otp.errors.messages).to have_key(:otp)
      end
    end

    context 'When otp is not present' do
      it 'should not be valid' do
        otp = build(:otp_request, mobile_number: valid_mobile_number, otp: nil, expire_at: 10.minutes.from_now)

        expect(otp).not_to be_valid
        expect(otp.errors.messages).to have_key(:otp)
      end
    end
  end

  describe '#expired' do
    it 'should return true if the otp is expired' do
      otp = FactoryBot.build(:otp_request, mobile_number: '9898987987', otp: '678678', expire_at: 10.minutes.ago)
      expect(otp).to be_expired
    end

    it 'should return false if the otp is not expired' do
      otp = FactoryBot.build(:otp_request, mobile_number: '9898987987', otp: '678678', expire_at: 10.minutes.from_now)
      expect(otp).not_to be_expired
    end
  end
end
