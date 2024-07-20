class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  def validate_otp
    service = AuthenticationService.new(params[:mobile_number], params[:otp])
    response = service.process
    if response.error.present?
      render json: { errors: [response.error] }, status: :unprocessable_entity
    else
      render json: { data: { token: response.token } }, status: :ok
    end
  end
end
