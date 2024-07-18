require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe 'POST validate_otp' do
    let(:otp) { '123456' }
    let(:mobile_number) { '8298893857' }
    let(:auth_service) { instance_double(AuthenticationService) }

    context 'when AuthenticationService successfully processes the request' do
      let(:auth_response) { instance_double(AuthenticationService::Response, token: 'token-123', error: nil) }

      it 'returns the token from AuthenticationService with a status code 200' do
        allow(AuthenticationService).to receive(:new).with(mobile_number, otp).and_return(auth_service)
        allow(auth_service).to receive(:process).and_return(auth_response)

        post :validate_otp, params: { otp: otp, mobile_number: mobile_number }
        response_body = response.parsed_body

        expect(response_body['data']['token']).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when AuthenticationService fails to validate the OTP' do
      let(:auth_response) do
        instance_double(AuthenticationService::Response, token: nil, error: 'OTP verification failed')
      end

      it 'returns the error from AuthenticationService with a status code 422' do
        allow(AuthenticationService).to receive(:new).with(mobile_number, otp).and_return(auth_service)
        allow(auth_service).to receive(:process).and_return(auth_response)

        post :validate_otp, params: { otp: otp, mobile_number: mobile_number }
        response_body = response.parsed_body

        expect(response_body['errors']).to include(auth_response.error)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
