# frozen_string_literal: true

require 'rails_helper'

describe MessageBirdAdapter do
  before(:each) do
    MessageBirdAdapter.deliveries.clear
  end

  describe 'initialize' do
    it 'should create a new message bird client with the accesskey' do
      result = described_class.new(false)
      expect(result.instance_variable_get(:@client)).to_not be_blank
      expect(result.client).to be_a MessageBird::Client
      expect(result.client.access_key).to eq ENV['MESSAGEBIRD_ACCESS_KEY']
    end

    it 'should store whether the object is in testmode' do
      [false, true].each do |bool|
        result = described_class.new(bool)
        expect(result.instance_variable_get(:@test_mode)).to_not be_nil
        expect(result.test_mode).to eq bool
      end
    end
  end

  describe 'send_text' do
    describe 'not in test mode' do
      let(:adapter) { MessageBirdAdapter.new false }

      it 'sends messages' do
        expect_any_instance_of(MessageBird::Client).to receive(:message_create)
          .with('FromName', '+31612341234', 'Body of text', reference: nil).and_return(true)
        result = adapter.send_text('FromName', '+31612341234', 'Body of text')
        expect(result).to be_truthy
      end
    end

    describe 'in test mode' do
      let(:adapter) { MessageBirdAdapter.new true }

      it 'stores messages' do
        result = adapter.send_text('FromName', '0612345678', 'Body of text')
        expect(result).to be_truthy
        expect(described_class.deliveries.length).to eq 1
        expect(described_class.deliveries.first).to include(from: 'FromName',
                                                            to: '0612345678',
                                                            body: 'Body of text',
                                                            reference: nil)
      end
    end
  end

  describe 'self.deliveries' do
    it 'should retain a class variable with deliveries' do
      result = described_class.instance_variable_get(:@deliveries)
      expect(result).to be_blank
      described_class.deliveries << 'test'
      expect(result).to_not be_blank
    end

    it 'should store the added deliveries' do
      described_class.deliveries << 'test'
      expect(described_class.deliveries.length).to eq 1
      described_class.deliveries << 'test2'
      expect(described_class.deliveries.length).to eq 2
      expect(described_class.deliveries).to match_array %w[test test2]
    end
  end
end
