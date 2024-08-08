require 'rails_helper'

RSpec.describe ParkingLot do
  subject(:parking_lot) { build(:parking_lot, owner: user) }

  let(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.to define_enum_for(:verification_status).with_values([:pending, :approved, :rejected]) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:parking_lot_vehicle_details) }

    it {
      expect(parking_lot)
        .to validate_numericality_of(:latitude)
        .is_greater_than_or_equal_to(-90)
        .is_less_than_or_equal_to(90)
    }

    it {
      expect(parking_lot)
        .to validate_numericality_of(:longitude)
        .is_greater_than_or_equal_to(-180)
        .is_less_than_or_equal_to(180)
    }

    it 'is valid with valid attributes' do
      expect(parking_lot).to be_valid
    end

    it 'is invalid with invalid attributes' do
      parking_lot.verification_status = ''
      expect(parking_lot).not_to be_valid
    end

    it 'is invalid when address is not present' do
      parking_lot.address = nil
      expect(parking_lot).not_to be_valid
    end

    it 'is invalid when parking lot vehicle details are not present' do
      parking_lot.parking_lot_vehicle_details = []
      expect(parking_lot).not_to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:owner).class_name('User') }
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_many :parking_lot_vehicle_details }

    it 'creates an associated address' do
      expect(parking_lot.address).to be_present
    end
  end
end
