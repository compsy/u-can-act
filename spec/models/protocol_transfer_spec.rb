# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProtocolTransfer, type: :model do
  describe 'validations' do
    let(:transfer) { FactoryBot.build(:protocol_transfer) }
    it 'should have a valid factory' do
      expect(transfer).to be_valid
    end

    it 'should validate the presence of a protocol_subscription' do
      transfer.protocol_subscription = nil
      expected_error = { protocol_subscription: ['moet opgegeven zijn'] }
      expect(transfer).to_not be_valid
      expect(transfer.errors).to_not be_blank
      expect(transfer.errors.messages).to eq expected_error
    end

    it 'should validate the presence of a from person' do
      transfer.from = nil
      expected_error = { from: ['moet opgegeven zijn'] }
      expect(transfer).to_not be_valid
      expect(transfer.errors).to_not be_blank
      expect(transfer.errors.messages).to eq expected_error
    end

    it 'should validate the presence of a to person' do
      transfer.to = nil
      expected_error = { to: ['moet opgegeven zijn'] }
      expect(transfer).to_not be_valid
      expect(transfer.errors).to_not be_blank
      expect(transfer.errors.messages).to eq expected_error
    end

    it 'should validate that from and to are not equal' do
      transfer.to = transfer.from
      expected_error = { from: ['mag niet hetzelfde zijn als to'] }
      expect(transfer).to_not be_valid
      expect(transfer.errors).to_not be_blank
      expect(transfer.errors.messages).to eq expected_error
    end
  end
end
