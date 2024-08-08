require 'rails_helper'

RSpec.describe ParkingLotsController, type: :controller do
  RSpec::Matchers.define_negated_matcher :not_change, :change

  let(:user) { create(:user) }
  let!(:parking_lot) { create(:parking_lot, owner: user) }

  let(:valid_parking_lot_attributes) do
    attributes_for(:parking_lot).merge(
      owner_id: user.id,
      address_attributes: attributes_for(:address),
      parking_lot_vehicle_details_attributes: [attributes_for(:parking_lot_vehicle_detail)]
    )
  end
  let(:invalid_parking_lot_attributes) do
    attributes_for(:parking_lot, latitude: nil, address: {
                     address_line_first: '', address_line_second: '', pin_code: '000000'
                   })
  end

  let(:token) { 'valid.token.here' }

  before do
    allow(controller).to receive(:authenticate_request).and_call_original
    allow(controller).to receive(:decode_token).with(token).and_return({ mobile_number: user.mobile_number })
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST /parking_lots' do
    context 'when user is not authenticated' do
      before do
        request.headers['Authorization'] = nil
      end

      it 'returns unauthorized status' do
        post :create, params: { parking_lot: valid_parking_lot_attributes }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Unauthorized')
      end
    end

    context 'when user is authenticated' do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      context 'with valid parameters' do
        it 'creates a new ParkingLot, Address, and ParkingLotVehicleDetail' do
          expect do
            post :create, params: { parking_lot: valid_parking_lot_attributes }
          end.to change(ParkingLot, :count).by(1)
                                           .and change(Address, :count).by(1)
                                                                       .and change(ParkingLotVehicleDetail,
                                                                                   :count).by(1)
        end

        it 'returns a success response (status code 200)' do
          post :create, params: { parking_lot: valid_parking_lot_attributes }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new ParkingLot' do
          expect do
            post :create, params: { parking_lot: invalid_parking_lot_attributes }
          end.to not_change(ParkingLot, :count)
            .and not_change(Address, :count)
            .and not_change(ParkingLotVehicleDetail, :count)
        end

        it 'returns an unprocessable entity status (status code 422)' do
          post :create, params: { parking_lot: invalid_parking_lot_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT /parking_lots' do
    context 'when user is not authenticated' do
      before do
        request.headers['Authorization'] = nil
      end

      it 'returns unauthorized status' do
        put :update, params: { id: parking_lot.id, parking_lot: valid_parking_lot_attributes }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Unauthorized')
      end
    end

    context 'when user is authenticated' do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      context 'with valid parameters' do
        it 'updates ParkingLot' do
          updating_attributes = { latitude: 86.6312148, longitude: -45.4857535 }
          put :update, params: { id: parking_lot.id, parking_lot: updating_attributes }
          parking_lot.reload
          expect(parking_lot.latitude).to eq(86.6312148)
          expect(parking_lot.longitude).to eq(-45.4857535)
        end

        it 'updates Address' do
          updating_attributes = { address_attributes: { id: parking_lot.address.id, pin_code: '500500' } }
          put :update, params: { id: parking_lot.id, parking_lot: updating_attributes }
          parking_lot.reload
          expect(parking_lot.address.pin_code).to eq('500500')
        end

        it 'updates ParkingLotVehicleDetails' do
          updating_attributes = { parking_lot_vehicle_details_attributes: {
            id: parking_lot.parking_lot_vehicle_details.first.id, capacity: 6
          } }
          put :update, params: { id: parking_lot.id, parking_lot: updating_attributes }
          parking_lot.reload
          expect(parking_lot.parking_lot_vehicle_details.first.capacity).to eq(6)
        end

        it 'returns a successful response' do
          updating_attributes = { latitude: 86.6312148, longitude: -45.4857535 }
          put :update, params: { id: parking_lot.id, parking_lot: updating_attributes }
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body['data']['parking_lot']['latitude']).to eq('86.6312148')
          expect(response.parsed_body['data']['parking_lot']['longitude']).to eq('-45.4857535')
        end
      end

      context 'with invalid parameters' do
        it 'does not update the parking lot' do
          updating_attributes = { latitude: nil, longitude: -45.4857535 }
          put :update, params: { id: parking_lot.id, parking_lot: updating_attributes }
          parking_lot.reload
          expect(parking_lot.latitude).not_to be_nil
        end

        it 'returns an unprocessable entity response' do
          updating_attributes = { latitude: nil, longitude: -45.4857535 }
          put :update, params: { id: parking_lot.id, parking_lot: updating_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body['errors']).to be_present
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when user is not authenticated' do
      before do
        request.headers['Authorization'] = nil
      end

      it 'returns unauthorized status' do
        delete :destroy, params: { id: parking_lot.id }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Unauthorized')
      end
    end

    context 'when user is authenticated' do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      context 'when the parking lot is successfully deleted' do
        it 'returns a success response' do
          delete :destroy, params: { id: parking_lot.id }
          expect(response).to have_http_status(:ok)
        end

        it 'removes the parking lot from the database' do
          expect do
            delete :destroy, params: { id: parking_lot.id }
          end.to change(ParkingLot, :count).by(-1)
                                           .and change(Address, :count).by(-1)
                                                                       .and change(ParkingLotVehicleDetail,
                                                                                   :count).by(-1)
        end
      end

      context 'when the parking lot does not exist' do
        it 'raises NoMethodError due to nil destroy' do
          allow(ParkingLot).to receive(:find_by).and_return(nil)

          expect do
            delete :destroy, params: { id: 0 }
          end.to raise_error(NoMethodError, /undefined method `destroy' for nil:NilClass/)
        end
      end
    end
  end

  describe '#generate_parking_lot_code' do
    context 'when creating a new parking lot' do
      it 'generates a unique parking_lot_code' do
        first_parking_lot = create(:parking_lot, owner: user)
        second_parking_lot = create(:parking_lot, owner: user)
        pl_code = first_parking_lot.code.delete('PL').to_i + 1
        expect(second_parking_lot.code).to eq("PL#{pl_code}")
      end
    end
  end
end
