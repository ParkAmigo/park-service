# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationService do
  describe '#process' do
    let(:mobile_number) { '9288402094' }
    let(:otp) { '299493' }

    context 'when there is no matching record in OtpRequest for the given mobile number and otp combination' do
      it 'returns an error' do
        service = described_class.new(mobile_number, otp)
        response = service.process

        expect(response.token).to be_nil
        expect(response.error).to eq('Could not find a matching OTP code')
      end
    end

    context 'when there exists an OtpRequest record for the given mobile number and otp but it is expired' do
      before do
        create(:otp_request, mobile_number: mobile_number, otp: otp, expire_at: 5.hours.ago)
      end

      it 'returns an error' do
        service = described_class.new(mobile_number, otp)
        response = service.process

        expect(response.token).to be_nil
        expect(response.error).to eq('OTP is expired')
      end
    end

    context 'when the OTP verification is successful' do
      before do
        create(:otp_request, mobile_number: mobile_number, otp: otp, expire_at: 10.minutes.from_now)
      end

      context 'with no user record present in db having the given mobile number' do
        it 'creates a user and return the JWT token generated' do
          service = described_class.new(mobile_number, otp)
          response = nil
          expect do
            response = service.process
          end.to change(User, :count).by(1)

          expect(response.token).not_to be_nil

          user = User.find_by(mobile_number: mobile_number)
          expect(user).not_to be_nil
        end
      end

      context 'with a user record present in db having the given mobile number' do
        before do
          create(:user, mobile_number: mobile_number)
        end

        it 'does not create a new user and simply return the JWT token generated' do
          service = described_class.new(mobile_number, otp)
          response = nil
          expect do
            response = service.process
          end.not_to change(User, :count)

          expect(response.token).not_to be_nil

          users = User.where(mobile_number: mobile_number)
          expect(users.count).to eq(1)
        end
      end
    end
  end
end
