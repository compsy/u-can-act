# frozen_string_literal: true

require 'rails_helper'

describe 'SvcMessages' do
  let(:described_class) { GenerateInvitationText }

  describe 'Student texts' do
    let(:person) { FactoryBot.create(:student) }
    let(:protocol) { FactoryBot.create(:protocol, :with_student_rewards) }
    let(:protocol_subscription) { FactoryBot.create(:protocol_subscription, person: person, protocol: protocol) }
    let(:voormeting) { FactoryBot.create(:questionnaire, name: 'voormeting mentoren') }
    let(:nameting) { FactoryBot.create(:questionnaire, name: 'nameting mentoren') }
    let(:measurement1) { FactoryBot.create(:measurement, questionnaire: voormeting) }
    let(:measurement2) { FactoryBot.create(:measurement) }
    let(:measurement3) { FactoryBot.create(:measurement, questionnaire: nameting) }

    let(:response) { FactoryBot.create(:response, protocol_subscription: protocol_subscription) }

    it 'should return the correct text when there are open voormeting questionnaires and completed some' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: true, streak: -1 }
      ]

      expected = 'Welkom bij de kick-off van het onderzoek \'u-can-act\'. Fijn dat je meedoet! ' \
       'Vandaag starten we met een aantal korte vragen, morgen begint de wekelijkse vragenlijst. ' \
       'Via de link kom je bij de vragen en een filmpje met meer info over u-can-act. Succes!'

      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
    end

    it 'should send a special message when the voormeting is not yet filled out' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: true, streak: -1 },
        { completed: true, periodical: true, reward_points: 0, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 0, future: true, streak: 2 }
      ]

      expected = 'Hartelijk dank voor je inzet! Naast de wekelijkse vragenlijst sturen we je deze week ' \
        'ook nog even de allereerste vragenlijst (de voormeting), die had je nog niet ingevuld. ' \
        'Je beloning loopt gewoon door natuurlijk!'

      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion

      result = described_class.run!(response: response)
      expect(result).to eq expected
    end

    it 'should send a special message for the first weekly questionnaire' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = 'Vul jouw eerste wekelijkse vragenlijst in en verdien twee euro!'

      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
    end

    it 'should send a special message when about to be on a streak' do
      protocol_completion = [
        { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 2 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 3 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 4 }
      ]
      expected = "Je bent goed bezig #{person.first_name}! Vul deze vragenlijst in en bereik de bonus-euro-streak!"

      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
    end

    it 'should send a special message when on a streak' do
      # Untestable from here?
    end

    it 'should send a special message when the first two responses were missed' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = "Vergeten te starten #{person.first_name}? Geen probleem, dat kan als nog! " \
                 'Start met het helpen van andere jongeren en vul de vragenlijst in.'

      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
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

      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
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
      expected = "Je was heel goed bezig met het onderzoek #{person.first_name}! " \
                 'Probeer je opnieuw de bonus-euro-streak te halen?'
      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
    end
    it 'should send a special message after more than one response was missed but there are completed responses' do
      protocol_completion = [
        { completed: false, periodical: false, reward_points: 0, future: false, streak: -1 },
        { completed: true, periodical: true, reward_points: 100, future: false, streak: 1 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: false, streak: 0 },
        { completed: false, periodical: true, reward_points: 100, future: true, streak: 1 }
      ]
      expected = "Je hebt ons al enorm geholpen met de vragenlijsten die je hebt ingevuld #{person.first_name}. " \
        'Wil je ons weer helpen?'
      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
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
      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
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
      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
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
      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
    end

    it 'should send a special 10 euro message when passing a reward threshold' do
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
      expect(protocol_subscription).to receive(:protocol_completion)
        .and_return protocol_completion
      result = described_class.run!(response: response)
      expect(result).to eq expected
    end

    describe 'reward thresholds' do
      after :each do
        protocol_completion = [
          { completed: true, periodical: false, reward_points: 0, future: false, streak: -1 }
        ]

        (1..@steps).each do |streak|
          protocol_completion << { completed: true, periodical: true, reward_points: 100,
                                   future: false, streak: streak }
        end

        protocol_completion << { completed: true, periodical: true, reward_points: 100, future: true, streak: @steps }

        expect(protocol_subscription).to receive(:protocol_completion)
          .and_return protocol_completion
        result = described_class.run!(response: response)
        expect(result).to eq @expected
      end

      it 'should send a special 10 euro message when passing a reward threshold' do
        @steps = 3
        @expected = 'Whoop! Na deze vragenlijst heb je €10,- verdiend. Ga zo door!'
      end

      it 'should send a special 20 euro message when passing a reward threshold' do
        @steps = 7
        @expected = "Je gaat hard #{person.first_name}! Na deze vragenlijst heb je al €20,- gespaard."
      end

      it 'should send a special 30 euro message when passing a reward threshold' do
        @steps = 10
        @expected = 'De teller blijft lopen! Na deze vragenlijst passeer jij de €30,- 😃'
      end

      it 'should send a special 40 euro message when passing a reward threshold' do
        @steps = 13
        @expected = "Hé #{person.first_name}. Door jouw goede inzet heb je bijna €40,- verdiend!"
      end

      it 'should send a special 50 euro message when passing a reward threshold' do
        @steps = 17
        @expected = 'Geweldig, na deze vragenlijst heb je al €50,- verdiend!'
      end

      it 'should send a special 60 euro message when passing a reward threshold' do
        @steps = 20
        @expected = 'Door jouw fantastische hulp heb jij al bijna €60,- verdiend!'
      end

      it 'should send a special 70 euro message when passing a reward threshold' do
        @steps = 23
        @expected = 'Weet jij al wat je gaat doen met de €70,- die jij na deze vragenlijst hebt verdiend?'
      end
    end

    describe 'default_pool' do
      it 'should never include the begeleider specific texts if the protocol has the name studenten_control' do
        # Impossible to test?
      end

      it 'should include the begeleider specific texts for other protocol names' do
        # Impossible to test?
      end
    end
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
