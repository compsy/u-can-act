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
      it 'should create an invitation token' do
        expect(response.invitation_token).to be_nil
        described_class.run!(response: response)
        expect(response.invitation_token).to_not be_nil
        expect(response.invitation_token.token).to_not be_nil
      end
      it 'should reuse the same token if one already exists' do
        FactoryGirl.create(:invitation_token, response: response)
        expect(response.invitation_token).to_not be_nil
        expect(response.invitation_token.token).to_not be_nil
        current_token = response.invitation_token.token
        described_class.run!(response: response)
        expect(response.invitation_token).to_not be_nil
        expect(response.invitation_token.token).to_not be_nil
        expect(response.invitation_token.token).to eq current_token
      end
      it 'should update the created_at when reusing a token' do
        FactoryGirl.create(:invitation_token, response: response, created_at: 3.days.ago)
        expect(response.invitation_token).to_not be_nil
        expect(response.invitation_token.created_at).to be_within(5.minutes).of(3.days.ago)
        current_token = response.invitation_token.token
        described_class.run!(response: response)
        expect(response.invitation_token).to_not be_nil
        expect(response.invitation_token.token).to_not be_nil
        expect(response.invitation_token.token).to eq current_token
        expect(response.invitation_token.created_at).to be_within(5.minutes).of(Time.zone.now)
      end
    end
    it 'should call the SendSms use case' do
      FactoryGirl.create(:invitation_token, response: response)
      mytok = response.invitation_token.token
      smstext = "Er staat een nieuwe vragenlijst voor je klaar. Vul deze nu in! #{ENV['HOST_URL']}/?q=#{mytok}"
      expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                             text: smstext,
                                             reference: "vsv-#{response.id}")
      described_class.run!(response: response)
    end
  end
end
