# frozen_string_literal: true

require 'rails_helper'

describe PushSubscription, type: :model do
  describe 'validations' do
    let(:push_subscription) { FactoryBot.create(:push_subscription) }

    it 'has a valid factory' do
      expect(push_subscription).to be_valid
      expect(push_subscription.protocol).to be_a(Protocol)
    end

    it 'validates the presence of a protocol' do
      push_subscription.protocol = nil
      expected_error = { protocol: ['moet bestaan'] }
      expect(push_subscription).not_to be_valid
      expect(push_subscription.errors).not_to be_blank
      expect(push_subscription.errors.messages).to eq expected_error
    end

    it 'validates the presence of a url' do
      push_subscription.url = nil
      expected_error = { url: ['moet opgegeven zijn'] }
      expect(push_subscription).not_to be_valid
      expect(push_subscription.errors).not_to be_blank
      expect(push_subscription.errors.messages).to eq expected_error
    end

    it 'validates the presence of a method' do
      push_subscription.method = nil
      expected_error = { method: ['is niet in de lijst opgenomen'] }
      expect(push_subscription).not_to be_valid
      expect(push_subscription.errors).not_to be_blank
      expect(push_subscription.errors.messages).to eq expected_error
    end

    it 'validates the presence of a name' do
      push_subscription.name = nil
      expected_error = { name: ['moet opgegeven zijn'] }
      expect(push_subscription).not_to be_valid
      expect(push_subscription.errors).not_to be_blank
      expect(push_subscription.errors.messages).to eq expected_error
    end

    it 'does not accept a random word as a method' do
      push_subscription.method = 'cookiedough'
      expected_error = { method: ['is niet in de lijst opgenomen'] }
      expect(push_subscription).not_to be_valid
      expect(push_subscription.errors).not_to be_blank
      expect(push_subscription.errors.messages).to eq expected_error
    end

    it 'accepts push subscriptions with the same name for different protocols' do
      FactoryBot.create(:push_subscription, name: 'ando')
      push_subscription.name = 'ando'
      expect(push_subscription).to be_valid
    end

    it 'validates that the combination of name and protocol is unique' do
      FactoryBot.create(:push_subscription, name: 'ando', protocol: push_subscription.protocol)
      push_subscription.name = 'ando'
      expected_error = { name: ['is al in gebruik'] }
      expect(push_subscription).not_to be_valid
      expect(push_subscription.errors).not_to be_blank
      expect(push_subscription.errors.messages).to eq expected_error
    end
  end
end
