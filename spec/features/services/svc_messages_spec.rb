# frozen_string_literal: true

require 'rails_helper'

describe 'SvcMessages' do
  let(:described_class) { GenerateInvitationText }

  describe 'Student texts' do
  end

  describe 'Mentor texts' do
    let(:voormeting) { FactoryBot.create(:questionnaire, name: 'voormeting mentoren') }
    let(:nameting) { FactoryBot.create(:questionnaire, name: 'nameting mentoren') }
    let(:measurement1) { FactoryBot.create(:measurement, questionnaire: voormeting) }
    let(:measurement2) { FactoryBot.create(:measurement) }
    let(:measurement3) { FactoryBot.create(:measurement, questionnaire: nameting) }

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
