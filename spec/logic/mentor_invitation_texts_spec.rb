# frozen_string_literal: true

require 'rails_helper'

describe MentorInvitationTexts do
  let(:voormeting) { FactoryBot.create(:questionnaire, name: 'voormeting mentoren') }
  let(:nameting) { FactoryBot.create(:questionnaire, name: 'nameting mentoren') }
  let(:protocol) { FactoryBot.create(:protocol) }
  let(:measurement1) { FactoryBot.create(:measurement, questionnaire: voormeting, protocol: protocol) }
  let(:measurement2) { FactoryBot.create(:measurement, protocol: protocol) }
  let(:measurement3) { FactoryBot.create(:measurement, questionnaire: nameting) }
  let(:mentor) { FactoryBot.create(:mentor) }

  let(:protocol_subscription) do
    FactoryBot.create(:protocol_subscription,
                      end_date: 10.days.from_now,
                      protocol: protocol, person: mentor)
  end
  let(:response) { FactoryBot.create(:response, protocol_subscription: protocol_subscription) }

  describe 'In the anouncement week' do
    before do
      Timecop.freeze(2018, 8, 2)
    end

    after do
      Timecop.return
    end

    it 'sends the correct message if the response is a post_assessment' do
      response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                              completed_at: nil,
                                              measurement: measurement3,
                                              open_from: 1.minute.ago)
      expected = 'Hoi Jane, wij willen net als jij graag vsv voorkomen. ' \
                 'Wil jij ons voor de laatste keer helpen en de laatste, maar cruciale, u-can-act vragenlijst invullen?'
      result = described_class.message(response)
      expect(result).to eq(expected)
    end

    it 'sends the correct message if the response is not a post_assessment' do
      response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                              completed_at: nil,
                                              measurement: measurement1,
                                              open_from: 1.minute.ago)
      expected = 'Hoi Jane, de allerlaatste vragenlijsten staan voor je klaar. Voor ons is het ontzettend belangrijk ' \
                 "dat deze wordt ingevuld. Help jij ons voor de laatste keer?\n" \
                 'Ps. Door aan te geven dat je inmiddels vakantie hebt, wordt de ' \
                 'vragenlijst een stuk korter dan je gewend bent .'
      result = described_class.message(response)
      expect(result).to eq(expected)
    end
  end

  describe 'Not in announcement week' do
    before do
      Timecop.freeze(2018, 7, 10)
    end

    after do
      Timecop.return
    end

    it 'returns the correct text when there are open voormeting questionnaires and completed some' do
      FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                   completed_at: 10.days.ago,
                                   open_from: 11.days.ago)

      response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                              completed_at: nil,
                                              measurement: measurement1,
                                              open_from: 1.minute.ago)

      result = described_class.message(response)
      expect(result).to eq 'Hartelijk dank voor je inzet! Naast de wekelijkse vragenlijst sturen we je deze ' \
                           'week ook nog even de allereerste vragenlijst (de voormeting), die had je nog niet ' \
                           'ingevuld. Na het invullen hiervan kom je weer bij de wekelijkse vragenlijst.'
    end

    it 'returns the correct text when there are open voormeting questionnaires and not completed some' do
      response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                              completed_at: nil,
                                              measurement: measurement1,
                                              open_from: 1.minute.ago)

      result = described_class.message(response)
      expect(result).to eq "Welkom bij de kick-off van het onderzoek 'u-can-act'. Vandaag staat " \
                           'informatie over het onderzoek en een korte voormeting voor je klaar. ' \
                           'Morgen start de eerste wekelijkse vragenlijst. Succes!'
    end

    it 'returns the correct text when the the voormeting is in a different protocol subscription' do
      response = FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription,
                                                        open_from: 1.minute.ago)
      result = described_class.message(response)
      expect(result).to eq 'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
                           'Vul nu de eerste wekelijkse vragenlijst in.'
    end

    it 'returns the default text otherwise' do
      result = described_class.message(response)
      expect(result).to eq "Hoi #{mentor.first_name}, je wekelijkse vragenlijsten staan weer voor je klaar!"
    end
  end
end
