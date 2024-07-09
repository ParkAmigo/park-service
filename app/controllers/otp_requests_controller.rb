# frozen_string_literal: true

class OtpRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    otp_request = OtpRequest.new(mobile_number: params[:mobile_number],
                                 otp: rand(OtpRequest::OTP_LOWER_BOUND..OtpRequest::OTP_UPPER_BOUND),
                                 expire_at: OtpRequest::OTP_EXPIRY_IN_MINUTES.minutes.from_now)
    if otp_request.save
      render json: { data: { otp: otp_request.otp } }, status: :ok
    else
      render json: { errors: otp_request.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
