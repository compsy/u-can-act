# frozen_string_literal: true

require 'rails_helper'

describe SendInvitation do
  let(:response) { FactoryGirl.create(:response) }
  let(:student) { FactoryGirl.create(:student) }
  let(:mentor) { FactoryGirl.create(:mentor) }

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

    describe 'when a student is filling out' do
      before :each do
        response.protocol_subscription.update_attributes!(person: student)
      end

      it 'should send the nameting sms whenever the questionnaire is a nameting and the person is a student' do
        questionnaire = FactoryGirl.create(:questionnaire, name: 'de nameting vragenlijst')
        response.measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire)
        FactoryGirl.create(:invitation_token, response: response)

        mytok = response.invitation_token.token
        smstext = 'Bedankt voor je inzet. Wij waarderen dit enorm! ' \
                  'Je krijgt je beloning als je deze laatste vragenlijst invult: ' \
                  "#{ENV['HOST_URL']}/?q=#{mytok}"

        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end

      it 'should send the normal text if the questionnaire is not a nameting' do
        questionnaire = FactoryGirl.create(:questionnaire, name: 'Studenten vragenlijst')
        response.measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire)
        FactoryGirl.create(:invitation_token, response: response)

        mytok = response.invitation_token.token
        smstext = "Je bent fantastisch op weg! Ga zo door. #{ENV['HOST_URL']}/?q=#{mytok}"
        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end
    end

    describe 'when a mentor is filling out' do
      before :each do
        response.protocol_subscription.update_attributes!(person: mentor)
      end

      it 'should send the normal text with the regular questionnaire' do
        questionnaire = FactoryGirl.create(:questionnaire, name: 'Mentoren vragenlijst')
        response.measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire)
        FactoryGirl.create(:invitation_token, response: response)
        mytok = response.invitation_token.token
        smstext = "Je bent fantastisch op weg! Ga zo door. #{ENV['HOST_URL']}/?q=#{mytok}"
        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end

      it 'should send the normal text on the nameting' do
        questionnaire = FactoryGirl.create(:questionnaire, name: 'Mentoren nameting vragenlijst')
        response.measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire)
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
end
