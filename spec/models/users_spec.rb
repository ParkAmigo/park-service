require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    subject(:user) { described_class.new }

    it { is_expected.to allow_value('user@example.com').for(:email).on(:update) }

    it {
      expect(user)
        .not_to allow_value('invalid_email')
        .for(:email)
        .with_message(I18n.t('activerecord.errors.messages.is_invalid'))
    }

    context 'when email is not present' do
      subject(:user) { described_class.new(email: nil) }

      it 'is valid' do
        expect(user).to be_valid
      end
    end
  end
end
