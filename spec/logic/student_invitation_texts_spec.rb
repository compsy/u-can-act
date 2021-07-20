# frozen_string_literal: true

require 'rails_helper'

describe StudentInvitationTexts do
  let(:protocol) { FactoryBot.create(:protocol, :with_student_rewards) }
  let(:protocol_subscription) { FactoryBot.create(:protocol_subscription, protocol: protocol) }

  let(:voormeting) { FactoryBot.create(:questionnaire, name: 'voormeting mentoren') }
  let(:nameting) { FactoryBot.create(:questionnaire, name: 'nameting mentoren') }
  let(:measurement1) { FactoryBot.create(:measurement, questionnaire: voormeting) }
  let(:measurement2) { FactoryBot.create(:measurement) }
  let(:measurement3) { FactoryBot.create(:measurement, questionnaire: nameting) }

  describe 'message' do
    describe 'in announcement week' do
      before do
        Timecop.freeze(2018, 8, 2)
      end

      after do
        Timecop.return
      end

      it 'returns correct text' do
        expected = 'Hoi {{deze_student}}, je hebt geld verdiend met je deelname'\
                   ' aan u-can-act: dit is je laatste kans om te innen! Vul de laatste'\
                   ' vragenlijst en IBAN in, alleen dan kunnen we je beloning overmaken.'
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                measurement: measurement2,
                                                completed_at: nil,
                                                open_from: 1.minute.ago)
        result = described_class.message(response)
        expect(result).to eq(expected)
      end
    end

    describe 'not in announcement week' do
      before do
        Timecop.freeze(2018, 7, 10)
      end

      after do
        Timecop.return
      end

      it 'calls and return the pooled message' do
        expected = 'expected message'
        protocol_completion = [
          { completed: false, periodical: false, reward_points: 0, future: true, streak: -1 }
        ]
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                completed_at: nil,
                                                open_from: 1.minute.ago)
        expect(protocol_subscription).to receive(:protocol_completion)
          .and_return(protocol_completion)

        expect(described_class)
          .to receive(:pooled_message)
          .with(protocol, protocol_completion)
          .and_return expected
        result = described_class.message(response)
        expect(result).to eq expected
      end
    end
  end

  describe 'pooled message' do
    it 'sends the kick off message for the voormeting' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: true, streak: -1 }
      ]
      expected = 'Welkom bij de kick-off van het onderzoek \'u-can-act\'. Fijn dat je meedoet! ' \
                 'Vandaag starten we met een aantal korte vragen, morgen begint de wekelijkse vragenlijst. ' \
                 'Via de link kom je bij de vragen en een filmpje met meer info over u-can-act. Succes!'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message when the voormeting is not yet filled out' do
      Timecop.freeze(2018, 5, 19) do
        protocol_completion = [
          { completed: false, periodical: false, reward_points: 0, future: true, streak: -1 },
          { completed: true, periodical: true, reward_points: 0, future: false, streak: 1 },
          { completed: false, periodical: true, reward_points: 0, future: true, streak: 2 }
        ]
        expected = 'Hartelijk dank voor je inzet! Naast de wekelijkse vragenlijst sturen we je deze week ' \
                   'ook nog even de allereerste vragenlijst (de voormeting), die had je nog niet ingevuld. ' \
                   'Je beloning loopt gewoon door natuurlijk!'
        expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
      end
    end

    it 'sends a special message for the first weekly questionnaire' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Vul jouw eerste wekelijkse vragenlijst in en verdien twee euro!'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message when about to be on a streak' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 3 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 4 }
      ]
      expected = 'Je bent goed bezig {{deze_student}}! Vul deze vragenlijst in en bereik de bonus-euro-streak!'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message when on a streak' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 3 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 4 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 5 }
      ]
      expected_set = described_class.on_streak_pool
      expect(expected_set).to be_an Array
      expect(expected_set.size).to be > 5
      expect(expected_set).to be_member(described_class.pooled_message(protocol, protocol_completion))
    end

    it 'sends a special message when passing a reward threshold' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 3 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 4 }
      ]
      expected = 'Whoop! Na deze vragenlijst heb je €10,- verdiend. Ga zo door!'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 3 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 4 }
      ]
      expected = 'Whoop! Na deze vragenlijst heb je €10,- verdiend. Ga zo door!'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 3 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 4 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 5 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 6 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 7 },
        { completed: true, periodical: true, reward_points: 100, future: true, streak: 8 }
      ]
      expected = 'Je gaat hard {{deze_student}}! Na deze vragenlijst heb je al €20,- gespaard.'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message when the first two responses were missed' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Vergeten te starten {{deze_student}}? Geen probleem, dat kan als nog! ' \
                 'Start met het helpen van andere jongeren en vul de vragenlijst in.'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message after one response was missed but the one before that was completed' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'We hebben je gemist vorige week. Help je deze week weer mee?'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message after one response was missed but was on a streak before that' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 3 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Je was heel goed bezig met het onderzoek {{deze_student}}! ' \
                 'Probeer je opnieuw de bonus-euro-streak te halen?'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message after more than one response was missed but there are completed responses' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Je hebt ons al enorm geholpen met de vragenlijsten die je hebt ingevuld {{deze_student}}. ' \
                 'Wil je ons weer helpen?'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message when all periodical responses were missed' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Start met u-can-act en help jouw begeleiders en andere ' \
                 'jongeren terwijl jij €2,- per drie minuten verdient!'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message when rejoining after a single missed measurement' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 2 }
      ]
      expected = 'Na een weekje rust ben je er sinds de vorige week weer bij. Fijn dat je weer mee doet!'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end

    it 'sends a special message when rejoining after a single missed measurement' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 2 }
      ]
      expected = 'Sinds vorige week ben je er weer bij. Super! ' \
                 'Vul nog twee vragenlijsten in en jaag op de bonus euro\'s!'
      expect(described_class.pooled_message(protocol, protocol_completion)).to eq expected
    end
  end

  describe 'first_response_pool' do
    it 'does not raise an error' do
      expect do
        described_class.first_response_pool
      end.not_to raise_error
    end
  end

  describe 'repeated_first_response_pool' do
    it 'does not raise an error' do
      expect do
        described_class.repeated_first_response_pool
      end.not_to raise_error
    end
  end

  describe 'second_response_pool' do
    it 'does not raise an error' do
      expect do
        described_class.second_response_pool
      end.not_to raise_error
    end
  end

  describe 'rewards_threshold_pool' do
    it 'does not raise an error' do
      expect do
        described_class.rewards_threshold_pool(1)
      end.not_to raise_error
    end
    it 'has a message for 10 euro' do
      expect(described_class.rewards_threshold_pool(1000))
        .to eq ['Whoop! Na deze vragenlijst heb je €10,- verdiend. Ga zo door!']
    end
    it 'has a message for 10 euro' do
      expect(described_class.rewards_threshold_pool(2000))
        .to eq ['Je gaat hard {{deze_student}}! Na deze vragenlijst heb je al €20,- gespaard.']
    end
    it 'has a message for 10 euro' do
      expect(described_class.rewards_threshold_pool(3000))
        .to eq ['De teller blijft lopen! Na deze vragenlijst passeer jij de €30,- 😃']
    end
    it 'has a message for 10 euro' do
      expect(described_class.rewards_threshold_pool(4000))
        .to eq ['Hé {{deze_student}}. Door jouw goede inzet heb je bijna €40,- verdiend!']
    end
    it 'has a message for 10 euro' do
      expect(described_class.rewards_threshold_pool(5000))
        .to eq ['Geweldig, na deze vragenlijst heb je al €50,- verdiend!']
    end
    it 'has a message for 10 euro' do
      expect(described_class.rewards_threshold_pool(6000))
        .to eq ['Door jouw fantastische hulp heb jij al bijna €60,- verdiend!']
    end
    it 'has a message for 10 euro' do
      expect(described_class.rewards_threshold_pool(7000))
        .to eq ['Weet jij al wat je gaat doen met de €70,- die jij na deze vragenlijst hebt verdiend?']
    end
    it 'has a message for 10 euro' do
      expect(described_class.rewards_threshold_pool(8000))
        .to eq ['Wat heb jij je al ontzettend goed ingezet {{deze_student}}! Inmiddels heb je bijna €80,- verdiend.']
    end
    it 'returns an empty array otherwise' do
      expect(described_class.rewards_threshold_pool(10_000)).to eq []
    end
  end

  describe 'default_pool' do
    it 'does not raise an error with nil' do
      expect do
        described_class.default_pool(nil)
      end.not_to raise_error
    end

    it 'nevers include the begeleider specific texts if the protocol has the name studenten_control' do
      protocol = FactoryBot.create(:protocol, name: 'studenten_control')
      result = described_class.default_pool(protocol)
      expect(result).not_to include('Help {{naam_begeleider}} om {{zijn_haar_begeleider}} werk '\
                                    'beter te kunnen doen en vul deze vragenlijst in 😃.')
      expect(result).not_to include('Heel fijn dat je meedoet, hiermee help je {{naam_begeleider}} '\
                                    '{{zijn_haar_begeleider}} begeleiding te verbeteren!')

      # Check if the begeleider at all is in the text. Note that je_begeleidingsinitiatief and begeleiding are allowed.
      result = result.join
      expect(result).not_to match('begeleider')
    end

    it 'includes the begeleider specific texts for other protocol names' do
      protocol = FactoryBot.create(:protocol, name: 'other_protocol')
      result = described_class.default_pool(protocol)
      expect(result).to include('Help {{naam_begeleider}} om {{zijn_haar_begeleider}} werk '\
                                'beter te kunnen doen en vul deze vragenlijst in 😃.')
      expect(result).to include('Heel fijn dat je meedoet, hiermee help je {{naam_begeleider}} '\
                                '{{zijn_haar_begeleider}} begeleiding te verbeteren!')

      # Check if the begeleieder at all is in the text
      result = result.join
      expect(result).to match('begeleider')
    end
  end

  describe 'about_to_be_on_streak_pool' do
    it 'does not raise an error' do
      expect do
        described_class.about_to_be_on_streak_pool
      end.not_to raise_error
    end
  end

  describe 'on_streak_pool' do
    it 'does not raise an error' do
      expect do
        described_class.on_streak_pool
      end.not_to raise_error
    end
  end

  describe 'first_responses_missed_pool' do
    it 'does not raise an error' do
      expect do
        described_class.first_responses_missed_pool
      end.not_to raise_error
    end
  end

  describe 'missed_last_pool' do
    it 'does not raise an error' do
      expect do
        described_class.missed_last_pool
      end.not_to raise_error
    end
  end

  describe 'missed_more_than_one_pool' do
    it 'does not raise an error' do
      expect do
        described_class.missed_more_than_one_pool
      end.not_to raise_error
    end
  end

  describe 'missed_everything_pool' do
    it 'does not raise an error' do
      expect do
        described_class.missed_everything_pool
      end.not_to raise_error
    end
  end

  describe 'rejoined_after_missing_one_pool' do
    it 'does not raise an error' do
      expect do
        described_class.rejoined_after_missing_one_pool
      end.not_to raise_error
    end
  end

  describe 'rejoined_after_missing_multiple_pool' do
    it 'does not raise an error' do
      expect do
        described_class.rejoined_after_missing_multiple_pool
      end.not_to raise_error
    end
  end
end
