require 'rails_helper'

RSpec.describe VehicleType do
  let(:vehicle) { described_class.new(name: 'JCB') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    it 'is valid with valid attributes' do
      expect(vehicle).to be_valid
    end

    it 'is invalid with invalid attributes' do
      vehicle.name = nil
      expect(vehicle).not_to be_valid
    end
  end
end
