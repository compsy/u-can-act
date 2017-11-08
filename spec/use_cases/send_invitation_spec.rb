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

      it 'should send the voormeting sms whenever the questionnaire is a voormeting and the person is a student' do
        questionnaire = FactoryGirl.create(:questionnaire, name: 'de voormeting vragenlijst')
        response.measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire)
        FactoryGirl.create(:invitation_token, response: response)

        mytok = response.invitation_token.token
        smstext = "Welkom bij de kick-off van het onderzoek 'u-can-act'. Fijn " \
        'dat je meedoet! Vandaag starten we met een aantal korte vragen, morgen ' \
        'begint de wekelijkse vragenlijst. Via de link kom je bij de vragen en ' \
        'een filmpje met meer info over u-can-act. Succes! ' \
        "#{ENV['HOST_URL']}/?q=#{mytok}"

        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end

      it 'should send the first text if the questionnaire is not a voormeting and it is the first one' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   person: student,
                                                   start_date: 1.week.ago.at_beginning_of_day)
        voormeting = FactoryGirl.create(:questionnaire, name: 'voormeting')
        measurement = FactoryGirl.create(:measurement, questionnaire: voormeting)
        FactoryGirl.create(:response,
                           protocol_subscription: protocol_subscription,
                           open_from: 48.hours.ago,
                           completed_at: 10.hours.ago,
                           invited_state: Response::SENT_STATE,
                           measurement: measurement)

        dagboek = FactoryGirl.create(:questionnaire, name: 'dagboek')
        measurement = FactoryGirl.create(:measurement, questionnaire: dagboek)
        response = FactoryGirl.create(:response,
                                      protocol_subscription: protocol_subscription,
                                      open_from: 24.hour.ago,
                                      invited_state: Response::SENDING_STATE,
                                      measurement: measurement)

        FactoryGirl.create(:invitation_token, response: response)

        mytok = response.invitation_token.token
        smstext = "Vul jouw eerste wekelijkse vragenlijst in en verdien twee euro! #{ENV['HOST_URL']}/?q=#{mytok}"
        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end

      it 'should send the second text if the questionnaire is not a voormeting and it is not the first one' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   person: student,
                                                   start_date: 1.week.ago.at_beginning_of_day)
        voormeting = FactoryGirl.create(:questionnaire, name: 'voormeting')
        measurement = FactoryGirl.create(:measurement, questionnaire: voormeting)
        FactoryGirl.create(:response,
                           protocol_subscription: protocol_subscription,
                           open_from: 48.hours.ago,
                           completed_at: 10.hours.ago,
                           invited_state: Response::SENT_STATE,
                           measurement: measurement)

        dagboek = FactoryGirl.create(:questionnaire, name: 'dagboek')
        measurement = FactoryGirl.create(:measurement, questionnaire: dagboek)
        FactoryGirl.create(:response,
                           protocol_subscription: protocol_subscription,
                           open_from: 24.hour.ago,
                           completed_at: 10.hours.ago,
                           invited_state: Response::SENT_STATE,
                           measurement: measurement)
        response = FactoryGirl.create(:response,
                                      protocol_subscription: protocol_subscription,
                                      open_from: 24.hour.ago,
                                      invited_state: Response::SENDING_STATE,
                                      measurement: measurement)

        FactoryGirl.create(:invitation_token, response: response)

        mytok = response.invitation_token.token
        smstext = 'Fijn dat jij meedoet! Door jou kunnen ' \
          'jongeren nog betere begeleiding krijgen in de toekomst! ' \
          "#{ENV['HOST_URL']}/?q=#{mytok}"
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

      it 'should send the initial text with the voormeting questionnaire' do
        questionnaire = FactoryGirl.create(:questionnaire, name: 'Mentoren voormeting vragenlijst')
        response.measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire)
        FactoryGirl.create(:invitation_token, response: response)
        mytok = response.invitation_token.token

        smstext = "Welkom bij de kick-off van het onderzoek 'u-can-act'. Vandaag staat " \
        'informatie over het onderzoek en een korte voormeting voor je klaar. ' \
        'Morgen start de eerste wekelijkse vragenlijst. Succes! ' \
        "#{ENV['HOST_URL']}/?q=#{mytok}"
        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end

      it 'should send the first text if the questionnaire is not a voormeting and it is the first one' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   person: mentor,
                                                   filling_out_for: student,
                                                   start_date: 1.week.ago.at_beginning_of_day)
        voormeting = FactoryGirl.create(:questionnaire, name: 'voormeting')
        measurement = FactoryGirl.create(:measurement, questionnaire: voormeting)
        FactoryGirl.create(:response,
                           protocol_subscription: protocol_subscription,
                           open_from: 48.hours.ago,
                           completed_at: 10.hours.ago,
                           invited_state: Response::SENT_STATE,
                           measurement: measurement)

        dagboek = FactoryGirl.create(:questionnaire, name: 'dagboek')
        measurement = FactoryGirl.create(:measurement, questionnaire: dagboek)
        response = FactoryGirl.create(:response,
                                      protocol_subscription: protocol_subscription,
                                      open_from: 24.hour.ago,
                                      invited_state: Response::SENDING_STATE,
                                      measurement: measurement)

        FactoryGirl.create(:invitation_token, response: response)
        mytok = response.invitation_token.token

        smstext = 'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
          'Vul nu de eerste wekelijkse vragenlijst in. ' \
          "#{ENV['HOST_URL']}/?q=#{mytok}"
        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end

      it 'should send the second text if the questionnaire is not a voormeting and it is not the first one' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   person: mentor,
                                                   filling_out_for: student,
                                                   start_date: 1.week.ago.at_beginning_of_day)
        voormeting = FactoryGirl.create(:questionnaire, name: 'voormeting')
        measurement = FactoryGirl.create(:measurement, questionnaire: voormeting)
        FactoryGirl.create(:response,
                           protocol_subscription: protocol_subscription,
                           open_from: 48.hours.ago,
                           completed_at: 10.hours.ago,
                           invited_state: Response::SENT_STATE,
                           measurement: measurement)

        dagboek = FactoryGirl.create(:questionnaire, name: 'dagboek')
        measurement = FactoryGirl.create(:measurement, questionnaire: dagboek)
        FactoryGirl.create(:response,
                           protocol_subscription: protocol_subscription,
                           open_from: 24.hour.ago,
                           completed_at: 10.hours.ago,
                           invited_state: Response::SENT_STATE,
                           measurement: measurement)
        response = FactoryGirl.create(:response,
                                      protocol_subscription: protocol_subscription,
                                      open_from: 24.hour.ago,
                                      invited_state: Response::SENDING_STATE,
                                      measurement: measurement)

        FactoryGirl.create(:invitation_token, response: response)

        mytok = response.invitation_token.token

        smstext = 'Heel fijn dat je meedoet aan u-can-act! De volgende wekelijkse vragenlijst staat voor je klaar. ' \
          "#{ENV['HOST_URL']}/?q=#{mytok}"
        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end
    end
  end
end
