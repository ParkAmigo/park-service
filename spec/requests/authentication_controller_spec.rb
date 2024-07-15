require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe 'POST validate_otp' do
    let(:otp) { '123456' }
    let(:mobile_number) { '8298893857' }

    context 'When AuthenticationService successfully processes the request' do
      let(:auth_response) { double(AuthenticationService::Response, token: 'token-123', error: nil) }

      it 'should return the token returned by AuthenticationService with a status code 200' do
        expect_any_instance_of(AuthenticationService).to receive(:process).and_return(auth_response)

        post :validate_otp, params: { otp: otp, mobile_number: mobile_number }
        response_body = JSON.parse(response.body)

        expect(response_body['data']['token']).to be_present
        expect(response.status).to eq(200)
      end
    end
    context 'When AuthenticationService fails to validate the OTP' do
      let(:auth_response) { double(AuthenticationService::Response, token: nil, error: 'OTP verification failed') }

      it 'should return the error from AuthenticationService with a status code 422' do
        expect_any_instance_of(AuthenticationService).to receive(:process).and_return(auth_response)

        post :validate_otp, params: { otp: otp, mobile_number: mobile_number }
        response_body = JSON.parse(response.body)

        expect(response_body['data']).not_to be_present
        expect(response_body['errors']).to include(auth_response.error)
        expect(response.status).to eq(422)
      end
    end
  end
end