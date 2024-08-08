require 'rails_helper'

RSpec.describe Address do
  let(:parking_lot) { create(:parking_lot) }
  let(:address) { build(:address, parking_lot: parking_lot) }

  describe 'associations' do
    it { is_expected.to belong_to(:parking_lot) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:address_line_first) }
    it { is_expected.to validate_presence_of(:address_line_second) }
    it { is_expected.to validate_presence_of(:pin_code) }
    it { is_expected.to allow_value('560068').for(:pin_code) }
    it { is_expected.not_to allow_value('000000').for(:pin_code) }
    it { is_expected.not_to allow_value('1234').for(:pin_code) }

    it 'is valid with valid attributes' do
      expect(address).to be_valid
    end

    it 'is invalid with invalid attributes' do
      address.pin_code = '000000'
      expect(address).not_to be_valid
    end

    it 'have the correct parking_lot_id' do
      expect(address.parking_lot).to eq(parking_lot)
      expect(address.parking_lot_id).to eq(parking_lot.id)
    end
  end
end
