# frozen_string_literal: true

require 'rails_helper'

describe SendInvitation do
  let(:response) { FactoryGirl.create(:response) }

  describe 'Validations' do
    it 'should not accept a nil response' do
      expect { described_class.run!(response: nil) }
        .to raise_error(ActiveInteraction::InvalidInteractionError, 'Response is vereist')
      expect { described_class.run!(response: 123) }
        .to raise_error(ActiveInteraction::InvalidInteractionError, 'Response is geen geldige object')
    end
  end

  describe 'execute' do
    context 'invitation token' do
      before do
        expect(SendSms).to receive(:run!)
      end
      it 'should call the initialize_token_function of a response' do
        expect(response).to receive(:initialize_invitation_token!).and_call_original
        described_class.run!(response: response)
      end
    end
    it 'should call the SendSms use case' do
      FactoryGirl.create(:invitation_token, response: response)
      mytok = response.invitation_token.token
      smstext = "Je bent fantastisch op weg! Ga zo door. #{ENV['HOST_URL']}/?q=#{mytok}"
      expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                             text: smstext,
                                             reference: "vsv-#{response.id}")
      described_class.run!(response: response)
    end
  end
end
