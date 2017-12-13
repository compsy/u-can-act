# frozen_string_literal: true

require 'rails_helper'

describe StudentInvitationTexts do
  describe 'student_message' do
    let(:protocol) { FactoryGirl.create(:protocol, :with_student_rewards) }
    it 'should send the kick off message for the voormeting' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: true, streak: -1 }
      ]
      expected = 'Welkom bij de kick-off van het onderzoek ‘u-can-act’. Fijn dat je meedoet! ' \
       'Vandaag starten we met een aantal korte vragen, morgen begint de wekelijkse vragenlijst. ' \
       'Via de link kom je bij de vragen en een filmpje met meer info over u-can-act. Succes!'
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message for the first weekly questionnaire' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Vul jouw eerste wekelijkse vragenlijst in en verdien twee euro!'
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message when about to be on a streak' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 3 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 4 }
      ]
      expected = 'Je bent goed bezig {{deze_student}}! Vul deze vragenlijst in en bereik de bonus-euro-streak!'
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message when on a streak' do
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
      expect(expected_set.member?(described_class.student_message(protocol, protocol_completion))).to be_truthy
    end

    it 'should send a special message when passing a reward threshold' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 3 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 4 }
      ]
      expected = 'Whoop! Na deze vragenlijst heb je €10,- verdiend. Ga zo door!'
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
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
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
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
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message when the first two responses were missed' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Vergeten te starten {{deze_student}}? Geen probleem, dat kan als nog! ' \
                 'Start met het helpen van andere jongeren en vul de vragenlijst in.'
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message after one response was missed but the one before that was completed' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'We hebben je gemist vorige week. Help je deze week weer mee?'
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message after one response was missed but was on a streak before that' do
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
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message after more than one response was missed but there are completed responses' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Je hebt ons al enorm geholpen met de vragenlijsten die je hebt ingevuld {{deze_student}}. ' \
        'Wil je ons weer helpen?'
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message when all periodical responses were missed' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Start met u-can-act en help jouw begeleiders en andere ' \
                 'jongeren terwijl jij €2,- per drie minuten verdient!'
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message when rejoining after a single missed measurement' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 2 }
      ]
      expected = 'Na een weekje rust ben je er sinds de vorige week weer bij. Fijn dat je weer mee doet!'
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end

    it 'should send a special message when rejoining after a single missed measurement' do
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
      expect(described_class.student_message(protocol, protocol_completion)).to eq expected
    end
  end
  describe 'nth_response_pool' do
    it 'should not raise an error' do
      expect do
        described_class.nth_response_pool(1)
      end.not_to raise_error
    end
  end
  describe 'rewards_threshold_pool' do
    it 'should not raise an error' do
      expect do
        described_class.rewards_threshold_pool(1)
      end.not_to raise_error
    end
  end
  describe 'default_pool' do
    it 'should not raise an error' do
      expect do
        described_class.default_pool
      end.not_to raise_error
    end
  end
  describe 'about_to_be_on_streak_pool' do
    it 'should not raise an error' do
      expect do
        described_class.about_to_be_on_streak_pool
      end.not_to raise_error
    end
  end
  describe 'on_streak_pool' do
    it 'should not raise an error' do
      expect do
        described_class.on_streak_pool
      end.not_to raise_error
    end
  end
  describe 'first_responses_missed_pool' do
    it 'should not raise an error' do
      expect do
        described_class.first_responses_missed_pool
      end.not_to raise_error
    end
  end
  describe 'missed_last_pool' do
    it 'should not raise an error' do
      expect do
        described_class.missed_last_pool
      end.not_to raise_error
    end
  end
  describe 'missed_more_than_one_pool' do
    it 'should not raise an error' do
      expect do
        described_class.missed_more_than_one_pool
      end.not_to raise_error
    end
  end
  describe 'missed_everything_pool' do
    it 'should not raise an error' do
      expect do
        described_class.missed_everything_pool
      end.not_to raise_error
    end
  end
  describe 'rejoined_after_missing_one_pool' do
    it 'should not raise an error' do
      expect do
        described_class.rejoined_after_missing_one_pool
      end.not_to raise_error
    end
  end
  describe 'rejoined_after_missing_multiple_pool' do
    it 'should not raise an error' do
      expect do
        described_class.rejoined_after_missing_multiple_pool
      end.not_to raise_error
    end
  end
end
