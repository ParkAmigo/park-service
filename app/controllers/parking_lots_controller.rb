class ParkingLotsController < ApplicationController
  def create
    parking_lot = current_user.parking_lots.new(parking_lots_parameters)
    parking_lot.code = generate_code
    if parking_lot.save
      render json: { data: { parking_lot: parking_lot_response(parking_lot) } }, status: :ok
    else
      render json: { errors: [parking_lot.errors.full_messages.to_sentence] }, status: :unprocessable_entity
    end
  end

  def update
    parking_lot = ParkingLot.find_by(id: params[:id])
    if parking_lot.update(parking_lots_parameters)
      render json: { data: { parking_lot: parking_lot_response(parking_lot) } }, status: :ok
    else
      render json: { errors: [parking_lot.errors.full_messages.to_sentence] }, status: :unprocessable_entity
    end
  end

  def destroy
    parking_lot = ParkingLot.find_by(id: params[:id])
    if parking_lot.destroy
      render json: { data: { parking_lot: parking_lot_response(parking_lot) } }, status: :ok
    else
      render json: { errors: [parking_lot.errors.full_messages.to_sentence] }, status: :unprocessable_entity
    end
  end

  private

  def parking_lots_parameters
    params.require(:parking_lot).permit(
      :latitude, :longitude,
      address_attributes: [:id, :address_line_first, :address_line_second, :pin_code],
      parking_lot_vehicle_details_attributes:
        [:id, :vehicle_type_id, :capacity, :base_fare, :minimum_duration, :additional_charge_per_hour, :_destroy]
    )
  end

  def generate_code
    last_lot = ParkingLot.order(:created_at).last
    last_code_number = last_lot&.code&.delete('PL').to_i || 0
    next_code_number = last_code_number + 1
    "PL#{next_code_number}"
  end

  def parking_lot_response(parking_lot)
    ActiveModelSerializers::SerializableResource.new(parking_lot, serializer: ParkingLotSerializer).as_json
  end
end
