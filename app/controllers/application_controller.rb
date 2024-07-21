class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request

  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header&.split&.last

    return render json: { error: t('json_errors.unauthorized') }, status: :unauthorized unless token

    begin
      decoded_token = decode_token(token)
    rescue JWT::ExpiredSignature
      return render json: { error: t('json_errors.token_has_expired') }, status: :unauthorized
    rescue JWT::DecodeError
      return render json: { error: t('json_errors.unauthorized') }, status: :unauthorized
    end

    @current_user = User.find_by(mobile_number: decoded_token[:mobile_number])
    render json: { error: t('json_errors.unauthorized') }, status: :unauthorized unless @current_user

    # refresh token flow
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.credentials.jwt_private_key, true)[0].with_indifferent_access
  end
end
