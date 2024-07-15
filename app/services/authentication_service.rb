# frozen_string_literal: true

class AuthenticationService
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
    otp_request = OtpRequest.where(mobile_number: mobile_number, otp: otp).last
    unless otp_request.present?
      return Response.new(nil, 'Could not find a matching OTP code')
    end

    if otp_request.expired?
      return Response.new(nil, 'OTP is expired')
    end

    user = User.where(mobile_number: mobile_number).first_or_create!

    token = JWT.encode({ mobile_number: user.mobile_number, exp: 2.hours.from_now.to_i }, Rails.application.secrets.jwt_private_key)
    Response.new(token, nil)
  end
end
