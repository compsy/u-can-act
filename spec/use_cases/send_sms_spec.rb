# frozen_string_literal: true

require 'rails_helper'

describe SendSms do
  let(:number) { '0612341234' }
  let(:text) { 'This is a test text' }
  let(:reference) { 'reference' }

  before(:each) do
    MessageBirdAdapter.deliveries.clear
  end
  describe 'Validations' do
    it 'should fail if no phone number is provided (or provided in the wrong format)' do
      expect { described_class.run!(number: nil, text: text, reference: reference) }
        .to raise_error(ActiveInteraction::InvalidInteractionError, 'Number is vereist')
      expect { described_class.run!(number: 123, text: text, reference: reference) }
        .to raise_error(ActiveInteraction::InvalidInteractionError, 'Number is geen geldige string')
    end

    it 'should fail if no text is provided (or provided in the wrong format)' do
      expect { described_class.run!(number: number, text: nil, reference: reference) }
        .to raise_error(ActiveInteraction::InvalidInteractionError, 'Text is vereist')
      expect { described_class.run!(number: number, text: 123, reference: reference) }
        .to raise_error(ActiveInteraction::InvalidInteractionError, 'Text is geen geldige string')
    end

    it 'should fail if the reference is not provided (or provided in the wrong format)' do
      expect { described_class.run!(number: number, text: text, reference: nil) }
        .to raise_error(ActiveInteraction::InvalidInteractionError, 'Reference is vereist')
      expect { described_class.run!(number: number, text: text, reference: 123) }
        .to raise_error(ActiveInteraction::InvalidInteractionError, 'Reference is geen geldige string')
    end
  end

  describe 'execute' do
    it 'should raise if no api key is defined' do
      expect_any_instance_of(described_class).to receive(:credentials_provided?).and_return(false)
      expect { described_class.run!(number: number, text: text, reference: reference) }
        .to raise_error(RuntimeError, 'No Messagebird credentials are provided.')
    end

    it 'should raise if no sender is defined' do
      expect_any_instance_of(described_class).to receive(:messagebird_send_from_provided?).and_return(false)
      expect { described_class.run!(number: number, text: text, reference: reference) }
        .to raise_error(RuntimeError, 'No name to send the message from is provided.')
    end

    it 'should send a (fake) sms message' do
      described_class.run!(number: number, text: text, reference: reference)
      expect(MessageBirdAdapter.deliveries.size).to eq 1
      expect(MessageBirdAdapter.deliveries.first[:to]).to eq(number)
      expect(MessageBirdAdapter.deliveries.first[:body]).to include(text)
      expect(MessageBirdAdapter.deliveries.first[:reference]).to eq(reference)
    end

    it 'return the response of the sent text message' do
      response = described_class.run!(number: number, text: text, reference: reference)
      expect(response).to be_a(Array)
      expect(response.first).to be_a(Hash)
      expect(response.first.keys).to include(:client)
      expect(response.first.keys).to include(:to)
      expect(response.first.keys).to include(:from)
      expect(response.first.keys).to include(:body)
      expect(response.first.keys).to include(:reference)
    end
  end

  describe 'credentials_provided?' do
    it 'should return false if no api key is provided' do
      ENV['MESSAGEBIRD_ACCESS_KEY'] = nil
      expect(subject.send(:credentials_provided?)).to be_falsey
    end
    it 'should return true if an api key is provided' do
      ENV['MESSAGEBIRD_ACCESS_KEY'] = 'not nil!'
      expect(subject.send(:credentials_provided?)).to be_truthy
    end
  end
  describe 'messagebird_send_from_provided?' do
    it 'should return false if no api key is provided' do
      ENV['MESSAGEBIRD_SEND_FROM'] = nil
      expect(subject.send(:messagebird_send_from_provided?)).to be_falsey
    end
    it 'should return true if an api key is provided' do
      ENV['MESSAGEBIRD_SEND_FROM'] = 'not nil!'
      expect(subject.send(:messagebird_send_from_provided?)).to be_truthy
    end
  end
end
