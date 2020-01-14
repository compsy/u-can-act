# frozen_string_literal: true

class InvitationTexts
  MAX_REWARD_THRESHOLD = 8000

  class << self
    def message(_response)
      raise 'method message not implemented by subclass!'
    end

    def first_response_pool
      raise 'method first_response_pool not implemented by subclass!'
    end

    def repeated_first_response_pool
      raise 'method repeated_first_response_pool not implemented by subclass!'
    end

    def second_response_pool
      raise 'method second_response_pool not implemented by subclass!'
    end

    def rewards_threshold_pool(_threshold)
      raise 'method rewards_threshold_pool not implemented by subclass!'
    end

    def default_pool(_protocol)
      raise 'method default_pool not implemented by subclass!'
    end

    def about_to_be_on_streak_pool
      raise 'method about_to_be_on_streak_pool not implemented by subclass!'
    end

    def on_streak_pool
      raise 'method on_streak_pool not implemented by subclass!'
    end

    def first_responses_missed_pool
      raise 'method first_responses_missed_pool not implemented by subclass!'
    end

    def missed_last_pool
      raise 'method missed_last_pool not implemented by subclass!'
    end

    def missed_more_than_one_pool
      raise 'method missed_more_than_one_pool not implemented by subclass!'
    end

    def missed_everything_pool
      raise 'method missed_everything_pool not implemented by subclass!'
    end

    def rejoined_after_missing_one_pool
      raise 'method rejoined_after_missing_one_pool not implemented by subclass!'
    end

    def rejoined_after_missing_multiple_pool
      raise 'method rejoined_after_missing_multiple_pool not implemented by subclass!'
    end

    def missed_after_streak_pool
      raise 'method missed_after_streak_pool not implemented by subclass!'
    end

    private

    def in_announcement_week?
      Time.zone.now > Time.new(2018, 8, 1).in_time_zone &&
        Time.zone.now < Time.new(2018, 8, 8).in_time_zone
    end

    def post_assessment?(response)
      response.measurement.questionnaire.name.include? 'nameting'
    end

    def target_first_name(response)
      response.protocol_subscription.person.first_name
    end

    def streak_conditions(protocol_completion, curidx)
      sms_pool = []

      # Streak about to be 3
      sms_pool += about_to_be_on_streak_pool if protocol_completion[curidx][:streak] == streak_size

      # On bonus streak (== on streak > 3)
      sms_pool += on_streak_pool if protocol_completion[curidx][:streak] > streak_size && sms_pool.empty?

      sms_pool
    end

    def threshold_conditions(protocol, protocol_completion, curidx)
      current_protocol_completion = truncated_protocol_completion(protocol_completion, curidx)
      rewards_before = protocol.calculate_reward(current_protocol_completion, false)
      rewards_after = protocol.calculate_reward(current_protocol_completion, true)

      sms_pool = []
      1000.step(MAX_REWARD_THRESHOLD, 1000) do |threshold| # 1000 = 10 euro
        sms_pool += rewards_threshold_pool(threshold) if rewards_before < threshold && rewards_after >= threshold
      end
      sms_pool
    end

    def special_conditions(protocol_completion, curidx)
      sms_pool = []

      sms_pool += first_responses_conditions(protocol_completion, curidx)
      sms_pool += missed_responses_conditions(protocol_completion, curidx) if sms_pool.empty?
      sms_pool += rejoined_conditions(protocol_completion, curidx) if sms_pool.empty?

      sms_pool
    end

    def rejoined_conditions(protocol_completion, curidx)
      sms_pool = []

      # Opnieuw gestart na 1 gemiste meting
      sms_pool += rejoined_after_missing_one_pool if rejoined_after_missing_one(protocol_completion, curidx)

      # Opnieuw gestart na 2+ metingen te hebben gemist
      sms_pool += rejoined_after_missing_multiple_pool if rejoined_after_missing_multiple(protocol_completion,
                                                                                          curidx) && sms_pool.empty?

      sms_pool
    end

    def missed_responses_conditions(protocol_completion, curidx)
      sms_pool = []

      sms_pool += only_missed_last_response(protocol_completion, curidx)

      # Twee of meer vragenlijsten gemist (wel eerder vragenlijsten ingevuld)
      sms_pool += missed_more_than_one_pool if missed_more_than_one(protocol_completion, curidx) && sms_pool.empty?

      # Alles tot nu toe gemist
      # Een vragenlijst gemist en nog nooit een vragenlijst ingevuld (geldt niet bij de tweede vragenlijst)
      # Only if the previous ones did not apply
      sms_pool += missed_everything_pool if missed_everything(protocol_completion, curidx) && sms_pool.empty?

      sms_pool
    end

    def only_missed_last_response(protocol_completion, curidx)
      sms_pool = []

      # Laatste vragenlijst gemist, zat in streak
      sms_pool += missed_after_streak_pool if missed_one_after_streak_pool(protocol_completion, curidx)

      # Laatste vragenlijst gemist, maar wel eerder vragenlijsten ingevuld
      sms_pool += missed_last_pool if missed_last_only(protocol_completion, curidx) && sms_pool.empty?

      sms_pool
    end

    def first_responses_conditions(protocol_completion, curidx)
      sms_pool = []

      sms_pool += first_response_conditions(protocol_completion, curidx) if curidx.zero?

      # Eerste dagboekmeting
      sms_pool += second_response_pool if curidx == 1 && sms_pool.empty?

      # Eerste twee metingen gemist
      sms_pool += first_responses_missed_pool if missed_first_two_responses(protocol_completion, curidx) &&
                                                 sms_pool.empty?

      sms_pool
    end

    def first_response_conditions(protocol_completion, _curidx)
      sms_pool = []

      # Repeated Voormeting
      sms_pool += repeated_first_response_pool if completed_some?(protocol_completion)

      # Voormeting
      sms_pool += first_response_pool if !completed_some?(protocol_completion) && sms_pool.empty?

      sms_pool
    end

    def current_index(protocol_completion)
      # -1 in case there are no other measurements
      protocol_completion.find_index { |entry| entry[:future] } || -1
    end

    def truncated_protocol_completion(protocol_completion, curidx)
      protocol_completion[0..curidx]
    end

    def completed_some?(protocol_completion)
      protocol_completion.map { |x| x[:completed] }.any?
    end

    def missed_first_two_responses(protocol_completion, curidx)
      # That is: the voormeting and the first periodical measurement
      # Minimal pattern: ..C         (V = voormeting, X = completed, C = current)
      #           index: 012
      curidx == 2 &&
        !protocol_completion[0][:completed] &&
        !protocol_completion[1][:completed]
    end

    def missed_last_only(protocol_completion, curidx)
      # Minimal pattern: VX.C         (V = voormeting, X = completed, C = current)
      #           index: 0123
      curidx > 2 &&
        !protocol_completion[curidx - 1][:completed] &&
        protocol_completion[curidx - 2][:completed]
    end

    def missed_one_after_streak_pool(protocol_completion, curidx)
      # Minimal pattern: VXXX.C         (V = voormeting, X = completed, C = current)
      #           index: 012345
      curidx > 2 && # only make sure that we can check the index at curidx-2.
        !protocol_completion[curidx - 1][:completed] &&
        protocol_completion[curidx - 2][:completed] &&
        protocol_completion[curidx - 2][:streak] >= streak_size
    end

    def missed_more_than_one(protocol_completion, curidx)
      # Minimal pattern: VX..C         (V = voormeting, X = completed, C = current)
      #           index: 01234
      curidx > 3 &&
        !protocol_completion[curidx - 1][:completed] &&
        !protocol_completion[curidx - 2][:completed] &&
        protocol_completion[1..(curidx - 3)].map { |x| x[:completed] }.any?
    end

    def missed_everything(protocol_completion, curidx)
      # Minimal pattern: V.C           (V = voormeting, X = completed, C = current)
      #           index: 012
      curidx > 1 &&
        protocol_completion[1..(curidx - 1)].map { |x| x[:completed] }.none?
    end

    def rejoined_after_missing_one(protocol_completion, curidx)
      # Minimal pattern: VX.XC         (V = voormeting, X = completed, C = current)
      #           index: 01234
      curidx > 3 &&
        protocol_completion[curidx - 1][:completed] &&
        !protocol_completion[curidx - 2][:completed] &&
        protocol_completion[curidx - 3][:completed]
    end

    def rejoined_after_missing_multiple(protocol_completion, curidx)
      # Minimal pattern: VX..XC         (V = voormeting, X = completed, C = current)
      #           index: 012345
      curidx > 4 &&
        protocol_completion[curidx - 1][:completed] &&
        !protocol_completion[curidx - 2][:completed] &&
        !protocol_completion[curidx - 3][:completed] &&
        protocol_completion[1..(curidx - 4)].map { |x| x[:completed] }.any?
    end

    def streak_size
      Protocol.find_by(name: 'studenten')&.rewards&.second&.threshold || 3
    end
  end
end
