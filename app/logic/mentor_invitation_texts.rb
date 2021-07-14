# frozen_string_literal: true

class MentorInvitationTexts < InvitationTexts
  class << self
    def message(response)
      return announcement_week_texts(response) if in_announcement_week?

      normal_texts(response)
    end

    private

    def announcement_week_texts(response)
      if post_assessment?(response)
        return "Hoi #{target_first_name(response)}, wij willen net als jij graag vsv voorkomen."\
               ' Wil jij ons voor de laatste keer helpen en de laatste, maar cruciale,'\
               ' u-can-act vragenlijst invullen?'
      end
      "Hoi #{target_first_name(response)}, de allerlaatste vragenlijsten"\
        ' staan voor je klaar. Voor ons is het ontzettend belangrijk dat deze'\
        " wordt ingevuld. Help jij ons voor de laatste keer?\n"\
        'Ps. Door aan te geven dat je inmiddels vakantie hebt, wordt de'\
        ' vragenlijst een stuk korter dan je gewend bent .'
    end

    def normal_texts(response)
      return pre_assessment_questionnaire_texts(response) if open_questionnaire?(response, 'voormeting mentoren')

      # voormeting is in different protsub
      return was_invited_message if response.protocol_subscription.responses.invited.count == 1

      default_message(response)
    end

    def was_invited_message
      'Fijn dat je wilt helpen om inzicht te krijgen in de ontwikkeling van jongeren! ' \
        'Vul nu de eerste wekelijkse vragenlijst in.'
    end

    def default_message(response)
      "Hoi #{target_first_name(response)}, je wekelijkse vragenlijsten staan weer voor je klaar!"
    end

    def pre_assessment_questionnaire_texts(response)
      if completed_some?(response)
        return 'Hartelijk dank voor je inzet! Naast de wekelijkse vragenlijst sturen we je deze ' \
               'week ook nog even de allereerste vragenlijst (de voormeting), die had je nog niet ' \
               'ingevuld. Na het invullen hiervan kom je weer bij de wekelijkse vragenlijst.'
      end
      "Welkom bij de kick-off van het onderzoek 'u-can-act'. Vandaag staat " \
        'informatie over het onderzoek en een korte voormeting voor je klaar. ' \
        'Morgen start de eerste wekelijkse vragenlijst. Succes!'
    end

    def open_questionnaire?(response, questionnaire_name)
      get_person(response).open_questionnaire?(questionnaire_name)
    end

    def completed_some?(response)
      get_person(response).responses.completed.count.positive?
    end

    def target_first_name(response)
      get_person(response).first_name
    end

    def get_person(response)
      response.protocol_subscription.person
    end
  end
end
