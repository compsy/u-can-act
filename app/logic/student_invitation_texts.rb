# frozen_string_literal: true

class StudentInvitationTexts < InvitationTexts
  class << self
    def message(response)
      return announcement_week_texts(response) if in_announcement_week?

      pooled_message(response.protocol_subscription.protocol,
                     response.protocol_subscription.protocol_completion)
    end

    def pooled_message(protocol, protocol_completion)
      curidx = current_index(protocol_completion)
      sms_pool = []

      sms_pool += special_conditions(protocol_completion, curidx)
      sms_pool += threshold_conditions(protocol, protocol_completion, curidx) if sms_pool.empty?
      sms_pool += streak_conditions(protocol_completion, curidx) if sms_pool.empty?
      sms_pool += default_pool(protocol) if sms_pool.empty?

      sms_pool.sample
    end

    def repeated_first_response_pool
      # Voormeting (repeated)
      [
        'Hartelijk dank voor je inzet! Naast de wekelijkse vragenlijst sturen we je deze week ' \
        'ook nog even de allereerste vragenlijst (de voormeting), die had je nog niet ingevuld. ' \
        'Je beloning loopt gewoon door natuurlijk!'
      ]
    end

    def first_response_pool
      # Voormeting
      [
        'Welkom bij de kick-off van het onderzoek \'u-can-act\'. Fijn dat je meedoet! ' \
        'Vandaag starten we met een aantal korte vragen, morgen begint de wekelijkse vragenlijst. ' \
        'Via de link kom je bij de vragen en een filmpje met meer info over u-can-act. Succes!'
      ]
    end

    def second_response_pool
      # Eerste wekelijkse vragenlijst
      [
        'Vul jouw eerste wekelijkse vragenlijst in en verdien twee euro!'
      ]
    end

    # rubocop:disable Metrics/MethodLength
    def rewards_threshold_pool(threshold)
      case threshold
      when 1000 # 10 euro
        [
          'Whoop! Na deze vragenlijst heb je €10,- verdiend. Ga zo door!'
        ]
      when 2000 # 20 euro
        [
          'Je gaat hard {{deze_student}}! Na deze vragenlijst heb je al €20,- gespaard.'
        ]
      when 3000 # 30 euro
        [
          'De teller blijft lopen! Na deze vragenlijst passeer jij de €30,- 😃'
        ]
      when 4000 # 40 euro
        [
          'Hé {{deze_student}}. Door jouw goede inzet heb je bijna €40,- verdiend!'
        ]
      when 5000 # 50 euro
        [
          'Geweldig, na deze vragenlijst heb je al €50,- verdiend!'
        ]
      when 6000 # 60 euro
        [
          'Door jouw fantastische hulp heb jij al bijna €60,- verdiend!'
        ]
      when 7000 # 70 euro
        [
          'Weet jij al wat je gaat doen met de €70,- die jij na deze vragenlijst hebt verdiend?'
        ]
      when 8000 # 80 euro
        [
          'Wat heb jij je al ontzettend goed ingezet {{deze_student}}! Inmiddels heb je bijna €80,- verdiend.'
        ]
      else
        []
      end
    end

    # rubocop:enable Metrics/MethodLength

    def default_pool(protocol)
      # TODO: make sure to replace newlines by spaces in the email template.
      invite_texts = [
        "Hoi {{deze_student}},\nEr staat een vragenlijst voor je klaar 😃.",
        'Een u-can-act tip: vul drie vragenlijsten achter elkaar in en verdien een euro extra per vragenlijst!',
        "Hoi {{deze_student}},\nVul direct de volgende vragenlijst in. Het kost maar 3 minuten en je helpt ons enorm!",
        "Hallo {{deze_student}},\nVerdien twee euro! Vul nu de vragenlijst in.",
        'Fijn dat jij meedoet! Door jou kunnen jongeren nog betere begeleiding krijgen in de toekomst!',
        'Help {{je_begeleidingsinitiatief}} nog beter te worden in wat ze doen en vul nu de vragenlijst in 😃.'
      ]

      if protocol&.name != 'studenten_control'
        invite_texts << 'Help {{naam_begeleider}} om {{zijn_haar_begeleider}} werk ' \
                        'beter te kunnen doen en vul deze vragenlijst in 😃.'
        invite_texts << 'Heel fijn dat je meedoet, hiermee help je {{naam_begeleider}} ' \
                        '{{zijn_haar_begeleider}} begeleiding te verbeteren!'
      end
      invite_texts
    end

    def about_to_be_on_streak_pool
      [
        'Je bent goed bezig {{deze_student}}! Vul deze vragenlijst in en bereik de bonus-euro-streak!'
      ]
    end

    def on_streak_pool
      [
        'Fijn dat je zo behulpzaam bent {{deze_student}}! Vul je opnieuw de vragenlijst in?',
        'Je zit nog steeds in je bonus-euro-streak! Jouw u-can-act spaarpot raakt al behoorlijk vol 😜.',
        'Bedankt voor je inzet! Ga zo door 😃.',
        '{{deze_student}}, je bent een topper! Bedankt voor je goede hulp!',
        'Goed bezig met je bonus-euro-streak, ga zo door!',
        'Super dat je de vragenlijst al zo vaak achter elkaar hebt ingevuld, bedankt en ga zo door!',
        "Hoi {{deze_student}},\nVul de vragenlijst in en verdien opnieuw drie euro!"
      ]
    end

    def first_responses_missed_pool
      [
        'Vergeten te starten {{deze_student}}? Geen probleem, dat kan als nog! ' \
        'Start met het helpen van andere jongeren en vul de vragenlijst in.'
      ]
    end

    def missed_last_pool
      [
        'We hebben je gemist vorige week. Help je deze week weer mee?'
      ]
    end

    def missed_after_streak_pool
      [
        'Je was heel goed bezig met het onderzoek {{deze_student}}! Probeer je opnieuw de bonus-euro-streak te halen?'
      ]
    end

    def missed_more_than_one_pool
      [
        'Je hebt ons al enorm geholpen met de vragenlijsten die je hebt ingevuld {{deze_student}}. ' \
        'Wil je ons weer helpen?'
      ]
    end

    def missed_everything_pool
      [
        'Start met u-can-act en help jouw begeleiders en andere jongeren terwijl jij €2,- per drie minuten verdient!'
      ]
    end

    def rejoined_after_missing_one_pool
      [
        'Na een weekje rust ben je er sinds de vorige week weer bij. Fijn dat je weer mee doet!'
      ]
    end

    def rejoined_after_missing_multiple_pool
      [
        'Sinds vorige week ben je er weer bij. Super! Vul nog twee vragenlijsten in en jaag op de bonus euro\'s!'
      ]
    end

    private

    def announcement_week_texts(_response)
      'Hoi {{deze_student}}, je hebt geld verdiend met je deelname aan u-can-act: dit ' \
        'is je laatste kans om te innen! Vul de laatste vragenlijst en IBAN in, ' \
        'alleen dan kunnen we je beloning overmaken.'
    end
  end
end
