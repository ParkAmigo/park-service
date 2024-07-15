class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token
  def validate_otp
    mobile_number = params[:mobile_number]
    otp = params[:otp]
    service = AuthenticationService.new(mobile_number, otp)
    response = service.process
    if response.error.present?
      render json: { errors: [response.error] }, status: :unprocessable_entity
    else
      render json: { data: { token: response.token } }, status: :ok
    end
  end
end
