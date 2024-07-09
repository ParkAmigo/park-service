require 'rails_helper'

RSpec.describe OtpRequestsController, type: :request do
  describe 'POST create' do
    context 'When a valid mobile number is passed' do
      it 'should create an otp' do
        mobile_number = '9202992910'
        expect do
          post otp_requests_path, params: { mobile_number: mobile_number }
        end.to change(OtpRequest, :count).by(1)

        result = JSON.parse(response.body).with_indifferent_access
        expect(result[:data][:otp]).to be_present
        expect(response.status).to eq(200)
      end
    end

    context 'When an invalid mobile number is passed' do
      it 'should throw an error' do
        mobile_number = '920299291A'
        expect do
          post otp_requests_path, params: { mobile_number: mobile_number }
        end.to change(OtpRequest, :count).by(0)

        result = JSON.parse(response.body).with_indifferent_access
        expect(result[:data]).not_to be_present
        expect(result[:errors]).to include('Mobile number is invalid')
        expect(response.status).to eq(422)
      end
    end
  end
end
