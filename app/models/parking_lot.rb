class ParkingLot < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: :parking_lots
  has_many :parking_lot_vehicle_details, dependent: :destroy
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :parking_lot_vehicle_details, allow_destroy: true

  enum verification_status: {
    pending: 0,
    approved: 1,
    rejected: 2
  }
  validates :address, :parking_lot_vehicle_details, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :verification_status, presence: true
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validate :unique_latitude_and_longitude_for_owner

  private

  def unique_latitude_and_longitude_for_owner
    existing_lot = ParkingLot.where(owner_id: owner_id, latitude: latitude, longitude: longitude)
                             .where.not(id: id).exists?
    return unless existing_lot

    errors.add(:base, I18n.t('activerecord.errors.messages.already_have_parking_lot_at_this_location'))
  end
end
