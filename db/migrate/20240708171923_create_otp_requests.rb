# frozen_string_literal: true
class CreateOtpRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :otp_requests do |t|
      t.string :mobile_number
      t.string :otp
      t.timestamp :expire_at

      t.timestamps
    end
  end
end
