require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    let(:user) { build(:user) }

    it { is_expected.to allow_value('user@example.com').for(:email).on(:update) }
    it { is_expected.to validate_presence_of(:mobile_number) }
    it { is_expected.to validate_length_of(:mobile_number).is_equal_to(OtpRequest::MOBILE_NUMBER_LENGTH) }
    it { is_expected.to allow_value('9828475892').for(:mobile_number) }
    it { is_expected.not_to allow_value('9828475').for(:mobile_number) }
    it { is_expected.not_to allow_value('9828475892000').for(:mobile_number) }

    it {
      expect(user)
        .not_to allow_value('invalid_email')
        .for(:email)
        .with_message(I18n.t('activerecord.errors.messages.is_invalid'))
    }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is valid when email is not present' do
      user.email = nil
      expect(user).to be_valid
    end
  end
end
