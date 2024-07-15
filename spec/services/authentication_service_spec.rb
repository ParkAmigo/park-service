# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationService do
  describe '#process' do
    let(:mobile_number) { '9288402094' }
    let(:otp) { '299493' }

    context 'When there is no matching record in OtpRequest for the given mobile number and otp combination' do
      it 'should return error' do
        service = AuthenticationService.new(mobile_number, otp)
        response = service.process

        expect(response.token).to be_nil
        expect(response.error).to eq('Could not find a matching OTP code')
      end
    end

    context 'When there exists an OtpRequest record for the given mobile number and otp but it is expired' do
      let!(:otp_request) { create(:otp_request, mobile_number: mobile_number, otp: otp, expire_at: 5.hours.ago) }

      it 'should return error' do
        service = AuthenticationService.new(mobile_number, otp)
        response = service.process

        expect(response.token).to be_nil
        expect(response.error).to eq('OTP is expired')
      end
    end

    context 'When a OTP verification is successful' do
      let!(:otp_request) { create(:otp_request, mobile_number: mobile_number, otp: otp, expire_at: 10.minutes.from_now) }

      context 'and a user record with the mobile number does not exists' do
        it 'should create a user and return the JWT token generated' do
          service = AuthenticationService.new(mobile_number, otp)
          response = nil
          expect do
            response = service.process
          end.to change { User.count }.by(1)

          expect(response.token).not_to be_nil

          user = User.find_by(mobile_number: mobile_number)
          expect(user).not_to be_nil
        end
      end

      context 'and a user record with the mobile number already exist in db' do
        let!(:user) { create(:user, mobile_number: mobile_number) }

        it 'should not create a new user and return the JWT token generated' do
          service = AuthenticationService.new(mobile_number, otp)
          response = nil
          expect do
            response = service.process
          end.to change { User.count }.by(0)

          expect(response.token).not_to be_nil

          users = User.where(mobile_number: mobile_number)
          expect(users.count).to eq(1)
        end
      end
    end
  end
end
