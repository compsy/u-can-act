# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProtocolTransfer, type: :model do
  describe 'validations' do
    let(:transfer) { FactoryBot.create(:protocol_transfer) }

    it 'has a valid factory' do
      expect(transfer).to be_valid
    end

    it 'validates the presence of a protocol_subscription' do
      transfer.protocol_subscription = nil
      expected_error = { protocol_subscription: ['moet opgegeven zijn'] }
      expect(transfer).not_to be_valid
      expect(transfer.errors).not_to be_blank
      expect(transfer.errors.messages).to eq expected_error
    end

    it 'validates the presence of a from person' do
      transfer.from = nil
      expected_error = { from: ['moet opgegeven zijn'] }
      expect(transfer).not_to be_valid
      expect(transfer.errors).not_to be_blank
      expect(transfer.errors.messages).to eq expected_error
    end

    it 'validates the presence of a to person' do
      transfer.to = nil
      expected_error = { to: ['moet opgegeven zijn'] }
      expect(transfer).not_to be_valid
      expect(transfer.errors).not_to be_blank
      expect(transfer.errors.messages).to eq expected_error
    end

    it 'validates that from and to are not equal' do
      transfer.to = transfer.from
      expected_error = { from: ['mag niet hetzelfde zijn als to'] }
      expect(transfer).not_to be_valid
      expect(transfer.errors).not_to be_blank
      expect(transfer.errors.messages).to eq expected_error
    end
  end
end
