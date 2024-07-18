class AddMissingDbConstraintsToOtpRequests < ActiveRecord::Migration[7.0]
  def change
    change_table :otp_requests, bulk: true do |t|
      t.change_null :mobile_number, false
      t.change_null :otp, false
      t.change_null :expire_at, false

      t.index [:mobile_number, :otp]
    end
  end
end
