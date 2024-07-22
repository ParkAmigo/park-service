require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_token) do
    JWT.encode({ mobile_number: user.mobile_number, exp: 1.hour.from_now.to_i },
               Rails.application.credentials.jwt_private_key)
  end
  let(:expired_token) do
    JWT.encode({ mobile_number: user.mobile_number, exp: 1.hour.ago.to_i },
               Rails.application.credentials.jwt_private_key)
  end
  let(:invalid_token) { 'invalid_token' }
  let(:decoded_token) { { mobile_number: user.mobile_number, exp: 1.hour.from_now.to_i } }

  controller do
    def dummy
      render plain: :ok
    end
  end

  before do
    allow(JWT).to receive(:decode).and_return([decoded_token])
    routes.draw { get 'dummy' => 'anonymous#dummy' }
    allow(controller).to receive(:authenticate_request).and_call_original
  end

  describe 'Authorization' do
    context 'when token is valid' do
      it "returns status 'ok' and sets current user" do
        request.headers['Authorization'] = "Bearer #{valid_token}"
        get :dummy
        expect(response).to have_http_status(:ok)
        expect(assigns(:current_user)).to eq(user)
      end
    end

    context 'when token is invalid' do
      it 'returns unauthorized status' do
        allow(JWT).to receive(:decode).and_raise(JWT::DecodeError)

        request.headers['Authorization'] = "Bearer #{invalid_token}"
        get :dummy
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['error']).to eq('Unauthorized')
      end
    end

    context 'when token is expired' do
      it 'returns token expired status' do
        allow(JWT).to receive(:decode).and_raise(JWT::ExpiredSignature)

        request.headers['Authorization'] = "Bearer #{expired_token}"
        get :dummy
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['error']).to eq('Token has expired')
      end
    end
  end
end
