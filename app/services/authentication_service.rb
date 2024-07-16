# frozen_string_literal: true

class AuthenticationService
  OTP_EXPIRY_IN_HOURS = 2
  OTP_EXPIRED_ERROR = 'OTP is expired'
  OTP_REQUEST_NOT_FOUND = 'Could not find a matching OTP code'

  class Response
    attr_reader :token, :error

    def initialize(token, error)
      @token = token
      @error = error
    end
  end

  attr_reader :mobile_number, :otp

  def initialize(mobile_number, otp)
    @mobile_number = mobile_number
    @otp = otp
  end

  def process
    otp_request = find_otp_request
    return response_for_otp_request_not_found if otp_request.blank?

    return response_for_expired_otp if otp_request.expired?

    user = find_or_create_user!
    generate_token_response(user)
  end

  private

  def generate_token_response(user)
    token = JWT.encode({ mobile_number: user.mobile_number, exp: OTP_EXPIRY_IN_HOURS.hours.from_now.to_i },
                       Rails.application.secrets.jwt_private_key)
    Response.new(token, nil)
  end

  def find_or_create_user!
    User.find_or_create_by!(mobile_number: mobile_number)
  end

  def response_for_expired_otp
    Response.new(nil, OTP_EXPIRED_ERROR)
  end

  def response_for_otp_request_not_found
    Response.new(nil, OTP_REQUEST_NOT_FOUND)
  end

  def find_otp_request
    OtpRequest.find_by(mobile_number: mobile_number, otp: otp)
  end
end
