# frozen_string_literal: true

require 'rails_helper'

describe SendInvitation do
  let(:protocol_subscription) { FactoryBot.create(:protocol_subscription, start_date: Time.zone.now.beginning_of_day) }
  let(:response) do
    FactoryBot.create(:response,
                      open_from: 10.minutes.ago.in_time_zone,
                      protocol_subscription: protocol_subscription)
  end
  let(:student) { FactoryBot.create(:student) }
  let(:mentor) { FactoryBot.create(:mentor) }

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
        questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
        response.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        FactoryBot.create(:invitation_token, response: response)

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
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        voormeting = FactoryBot.create(:questionnaire, name: 'voormeting')
        measurement = FactoryBot.create(:measurement, questionnaire: voormeting)
        FactoryBot.create(:response,
                          protocol_subscription: protocol_subscription,
                          open_from: 48.hours.ago,
                          completed_at: 10.hours.ago,
                          invited_state: Response::SENT_STATE,
                          measurement: measurement)

        dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
        measurement = FactoryBot.create(:measurement, questionnaire: dagboek, open_duration: 36.hours)
        response = FactoryBot.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 24.hour.ago,
                                     invited_state: Response::SENDING_STATE,
                                     measurement: measurement)

        FactoryBot.create(:invitation_token, response: response)

        mytok = response.invitation_token.token
        smstext = "Vul jouw eerste wekelijkse vragenlijst in en verdien twee euro! #{ENV['HOST_URL']}/?q=#{mytok}"
        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end

      it 'should send the second text if the questionnaire is not a voormeting and it is not the first one' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        voormeting = FactoryBot.create(:questionnaire, name: 'voormeting')
        measurement = FactoryBot.create(:measurement, questionnaire: voormeting)
        FactoryBot.create(:response,
                          protocol_subscription: protocol_subscription,
                          open_from: 48.hours.ago,
                          completed_at: 10.hours.ago,
                          invited_state: Response::SENT_STATE,
                          measurement: measurement)

        dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
        measurement = FactoryBot.create(:measurement, :periodical, questionnaire: dagboek, open_duration: 36.hours)
        FactoryBot.create(:response,
                          protocol_subscription: protocol_subscription,
                          open_from: 24.hour.ago,
                          completed_at: 10.hours.ago,
                          invited_state: Response::SENT_STATE,
                          measurement: measurement)
        response = FactoryBot.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 24.hour.ago,
                                     invited_state: Response::SENDING_STATE,
                                     measurement: measurement)

        FactoryBot.create(:invitation_token, response: response)

        mytok = response.invitation_token.token
        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: %r{ #{ENV['HOST_URL']}\/\?q=#{mytok}},
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end
    end

    describe 'when a mentor is filling out' do
      before :each do
        response.protocol_subscription.update_attributes!(person: mentor)
      end

      it 'should send the initial text with the voormeting questionnaire' do
        questionnaire = FactoryBot.create(:questionnaire, name: 'Mentoren voormeting vragenlijst')
        response.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
        FactoryBot.create(:invitation_token, response: response)
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
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: mentor,
                                                  filling_out_for: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
        measurement = FactoryBot.create(:measurement, questionnaire: dagboek)
        response = FactoryBot.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 24.hour.ago,
                                     invited_state: Response::SENDING_STATE,
                                     measurement: measurement)
        FactoryBot.create(:invitation_token, response: response)
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
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: mentor,
                                                  filling_out_for: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
        measurement = FactoryBot.create(:measurement, questionnaire: dagboek)
        FactoryBot.create(:response,
                          protocol_subscription: protocol_subscription,
                          open_from: 24.hour.ago,
                          completed_at: 10.hours.ago,
                          invited_state: Response::SENT_STATE,
                          measurement: measurement)
        response = FactoryBot.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 24.hour.ago,
                                     invited_state: Response::SENDING_STATE,
                                     measurement: measurement)
        FactoryBot.create(:invitation_token, response: response)
        mytok = response.invitation_token.token
        smstext = 'Hoi Jane, je wekelijkse vragenlijsten staan weer voor je klaar! ' \
          "#{ENV['HOST_URL']}/?q=#{mytok}"
        expect(SendSms).to receive(:run!).with(number: response.protocol_subscription.person.mobile_phone,
                                               text: smstext,
                                               reference: "vsv-#{response.id}")
        described_class.run!(response: response)
      end

      describe 'send mails' do
        it 'should not raise if the mail sending fails' do
          questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
          response.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
          FactoryBot.create(:invitation_token, response: response)
          allow(SendSms).to receive(:run!).with(any_args).and_return true
          allow(InvitationMailer).to receive(:invitation_mail).and_raise(RuntimeError, 'Crashing')
          expect { described_class.run!(response: response) }.to_not raise_error
        end

        it 'should call the logger if anything fails' do
          questionnaire = FactoryBot.create(:questionnaire, name: 'de voormeting vragenlijst')
          response.measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
          FactoryBot.create(:invitation_token, response: response)
          allow(SendSms).to receive(:run!).with(any_args).and_return true
          message = 'crashing'
          allow(InvitationMailer).to receive(:invitation_mail).and_raise(RuntimeError, message)
          expect(Rails.logger).to receive(:warn).with("[Attention] Mailgun failed again: #{message}").once
          expect(Rails.logger).to receive(:warn).with(any_args).once

          described_class.run!(response: response)
        end

        it 'should also send the invitation via email' do
          protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                    person: mentor,
                                                    filling_out_for: student,
                                                    start_date: 1.week.ago.at_beginning_of_day)
          dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
          measurement = FactoryBot.create(:measurement, questionnaire: dagboek)
          response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                  measurement: measurement)
          FactoryBot.create(:invitation_token, response: response)
          mytok = response.invitation_token.token
          message = 'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
            'Vul nu de eerste wekelijkse vragenlijst in.'

          allow(SendSms).to receive(:run!)
          invitation_url = "#{ENV['HOST_URL']}/?q=#{mytok}"
          expect(InvitationMailer).to receive(:invitation_mail).with(mentor.email,
                                                                     message,
                                                                     invitation_url).and_call_original
          described_class.run!(response: response)
          expect(ActionMailer::Base.deliveries.last.to.first).to eq mentor.email
        end

        it 'should not try to send an email if the mentor does not have an email address' do
          mentor.update_attributes!(email: nil)
          protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                    person: mentor,
                                                    filling_out_for: student,
                                                    start_date: 1.week.ago.at_beginning_of_day)
          dagboek = FactoryBot.create(:questionnaire, name: 'dagboek')
          measurement = FactoryBot.create(:measurement, questionnaire: dagboek)
          response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                  measurement: measurement)
          FactoryBot.create(:invitation_token, response: response)
          allow(SendSms).to receive(:run!)
          expect(InvitationMailer).to_not receive(:invitation_mail)
        end
      end
    end
  end
end
