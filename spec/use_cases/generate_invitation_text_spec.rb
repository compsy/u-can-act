# frozen_string_literal: true

require 'rails_helper'

describe GenerateInvitationText do
  describe 'run' do
    describe 'protocol with invitation text' do
      it 'should return the text of a protocol if one is set' do
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        result = described_class.run!(response: response)
        expect(result).to be_a String
        expect(result).to eq protocol.invitation_text
      end

      it 'should evaluate the values in the the text of a protocol' do
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        subs_hash = {}
        expected = 'expected outcome'
        expect(VariableSubstitutor).to receive(:substitute_variables)
          .with(response).and_return(subs_hash)
        expect(VariableEvaluator).to receive(:evaluate_obj)
          .with(protocol.invitation_text, subs_hash)
          .and_return(expected)

        result = described_class.run!(response: response)
        expect(result).to eq expected
      end
    end

    describe 'protocol without invitation text' do
      describe 'student' do
        let(:protocol) { FactoryBot.create(:protocol) }
        let(:student) { FactoryBot.create(:student) }
        let(:protocol_subscription) do
          FactoryBot.create(:protocol_subscription,
                            end_date: 10.days.from_now,
                            protocol: protocol, person: student)
        end
        let(:response) { FactoryBot.create(:response, protocol_subscription: protocol_subscription) }

        it 'should call the student invitation texts generator' do
          expected = 'test'
          expect(StudentInvitationTexts).to receive(:message)
            .with(protocol, protocol_subscription.protocol_completion)
            .and_return(expected)
          result = described_class.run!(response: response)
          expect(result).to eq(expected)
        end
      end

      describe 'mentor' do
        let(:questionnaire) { FactoryBot.create(:questionnaire, name: 'voormeting mentoren') }
        let(:measurement1) { FactoryBot.create(:measurement, questionnaire: questionnaire) }
        let(:measurement2) { FactoryBot.create(:measurement) }

        let(:protocol) { FactoryBot.create(:protocol, measurements: [measurement1, measurement2]) }
        let(:mentor) { FactoryBot.create(:mentor) }

        let(:protocol_subscription) do
          FactoryBot.create(:protocol_subscription,
                            end_date: 10.days.from_now,
                            protocol: protocol, person: mentor)
        end
        let(:response) { FactoryBot.create(:response, protocol_subscription: protocol_subscription) }

        it 'should return the correct text when there are open voormeting questionnaires and completed some' do
          FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                       completed_at: 10.days.ago,
                                       open_from: 11.days.ago)

          response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                  completed_at: nil,
                                                  measurement: measurement1,
                                                  open_from: 1.minute.ago)

          result = described_class.run!(response: response)
          expect(result).to eq 'Hartelijk dank voor je inzet! Naast de wekelijkse vragenlijst sturen we je deze ' \
                               'week ook nog even de allereerste vragenlijst (de voormeting), die had je nog niet ' \
                               'ingevuld. Na het invullen hiervan kom je weer bij de wekelijkse vragenlijst.'
        end

        it 'should return the correct text when there are open voormeting questionnaires and not completed some' do
          response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                  completed_at: nil,
                                                  measurement: measurement1,
                                                  open_from: 1.minute.ago)

          result = described_class.run!(response: response)
          expect(result).to eq "Welkom bij de kick-off van het onderzoek 'u-can-act'. Vandaag staat " \
                               'informatie over het onderzoek en een korte voormeting voor je klaar. ' \
                               'Morgen start de eerste wekelijkse vragenlijst. Succes!'
        end

        it 'should return the correct text when the the voormeting is in a different protocol subscription' do
          response = FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription,
                                                            open_from: 1.minute.ago)
          result = described_class.run!(response: response)
          expect(result).to eq 'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
       'Vul nu de eerste wekelijkse vragenlijst in.'
        end

        it 'should return the default text otherwise' do
          result = described_class.run!(response: response)
          expect(result).to eq "Hoi #{mentor.first_name}, je wekelijkse vragenlijsten staan weer voor je klaar!"
        end
      end
    end
  end
end
