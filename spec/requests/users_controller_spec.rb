require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:valid_attributes) { { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com' } }
  let(:invalid_attributes) { { email: 'invalid_email' } }
  let(:token) { 'valid.token.here' }

  before do
    allow(controller).to receive(:authenticate_request).and_call_original
    allow(controller).to receive(:decode_token).with(token).and_return({ mobile_number: user.mobile_number })
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'PUT #update' do
    context 'when user is not authenticated' do
      before do
        request.headers['Authorization'] = nil
      end

      it 'returns unauthorized status' do
        put :update, params: { id: user.id, user: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Unauthorized')
      end
    end

    context 'when user is authenticated' do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      context 'when user is not authorized' do
        it 'returns unauthorized status' do
          put :update, params: { id: other_user.id, user: valid_attributes }
          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to include('Unauthorized')
        end
      end

      context 'when user is found' do
        it 'updates the user and returns ok status with valid attributes' do
          put :update, params: { id: user.id, user: valid_attributes }
          user.reload
          expect(user.first_name).to eq('John')
          expect(user.last_name).to eq('Doe')
          expect(user.email).to eq('john.doe@example.com')
          expect(response).to have_http_status(:ok)
        end

        it 'does not update mobile number' do
          valid_attributes[:mobile_number] = '9854323232'
          put :update, params: { id: user.id, user: valid_attributes }
          user.reload
          expect(user.mobile_number).not_to eq('9854323232')
          expect(response).to have_http_status(:ok)
        end

        it 'does not update the user with invalid attributes' do
          put :update, params: { id: user.id, user: invalid_attributes }
          user.reload
          expect(user.email).not_to eq('invalid_email')
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body['errors']).to eq(['Email is Invalid'])
        end
      end

      context 'when user is found but update is unsuccessful' do
        it 'returns unprocessable entity status and error messages' do
          allow(User).to receive(:find_by).and_return(user)
          allow(user).to receive(:update).and_return(false)
          allow(user.errors).to receive(:full_messages).and_return(['Error message1', 'Error message2'])

          put :update, params: { id: user.id, user: valid_attributes }
          user.reload
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body['errors']).to include('Error message1 and Error message2')
        end
      end
    end
  end
end
