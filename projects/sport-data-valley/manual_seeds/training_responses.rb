# frozen_string_literal: true

require_relative 'helpers/people_helper'
srand(123)

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
module TrainingResponses
  extend PeopleHelper

  START_DATE = 10.weeks.ago.beginning_of_day # rubocop:disable Rails/RelativeDateConstant
  END_DATE = START_DATE + 10.weeks
  N_PARTICIPANTS = 5

  class << self
    def training_type
      types = %w[voetballen MTB hardlopen kracht]
      types[rand(types.count)]
    end

    def session_type
      types = ['ext uithoudingsvermogen',
               'ext interval',
               'fartlek',
               'general fitness',
               'int uithoudingsvermogen',
               'int interval',
               'int tempo',
               'anders',
               'race',
               'herstel']
      types[rand(types.count)]
    end

    def rpe_score
      scores = (1..9).map(&:to_s)
      scores[rand(9)]
    end

    def satisfaction
      scores = %w[2 2.5 3 3.5 3.5 4 4.5 5]
      scores[rand(scores.count)]
    end

    def duration
      durations = %w[30 45 60 120]
      durations[rand(4)]
    end

    def time_of_start(date)
      offsets = [7, 14, 18, 20]
      date.beginning_of_day + offsets[rand(offsets.count)].hours
    end

    def date_format(time_with_zone)
      time_with_zone.strftime('%F')
    end

    def hour_format(time_with_zone)
      time_with_zone.strftime('%H').to_i.to_s
    end

    def minute_format(time_with_zone)
      time_with_zone.strftime('%M').to_i.to_s
    end

    def create_training_log_response(person, timestamp)
      protocol_name = 'training_log'
      puts "Creating responses for #{protocol_name}"
      protocol = Protocol.find_by(name: protocol_name)
      raise "Error: protocol named #{protocol_name} not found" unless protocol

      protsub = ProtocolSubscription.find_by(person: person, protocol: protocol)
      protsub ||= ProtocolSubscription.new(person: person, protocol: protocol)

      protsub.state = ProtocolSubscription::COMPLETED_STATE
      protsub.start_date = START_DATE
      protsub.end_date = END_DATE + 1.week
      protsub.save!

      questionnaire_name = protocol_name
      questionnaire_id = Questionnaire.find_by(name: questionnaire_name).id
      measurement = protocol.measurements.where(questionnaire_id: questionnaire_id).first

      protsub_id = protsub.id
      measurement_id = measurement.id
      filled_out_by_id = protsub.person.id
      filled_out_for_id = protsub.filling_out_for.id

      Response.where(protocol_subscription_id: protsub_id, measurement_id: measurement_id).find_each do |response|
        ResponseContent.find(response.content).destroy if response.content.present?
        response.destroy
      end

      response_params = {}
      response_params[:protocol_subscription_id] = protsub_id
      response_params[:measurement_id] = measurement_id
      response_params[:filled_out_by_id] = filled_out_by_id
      response_params[:filled_out_for_id] = filled_out_for_id

      response_params[:open_from] = timestamp - 1.minute
      response_params[:opened_at] = timestamp
      response_params[:completed_at] = timestamp + 1.minute

      content = {}
      content[:v1] = training_type
      content[:v2] = session_type

      starting_at = time_of_start(timestamp)
      content[:v3] = date_format(starting_at)
      content[:v4_uren] = hour_format(starting_at)
      content[:v4_minuten] = minute_format(starting_at)

      content[:v5] = duration
      content[:v6] = rpe_score
      content[:v7] = satisfaction
      content[:v8] = 'a comment'

      response_content = ResponseContent.create_with_scores!(
        content: content,
        response: Response.new(measurement_id: response_params[:measurement_id])
      )
      response_params[:content] = response_content.id

      PushSubscriptionsJob.perform_later(Response.create!(response_params))
    end

    def create
      (1..N_PARTICIPANTS).each do |idx|
        person = find_or_create_person("questionnaire_participant_#{idx}@researchable.nl")

        date = START_DATE
        while date <= END_DATE
          create_training_log_response(person, date)

          date += 1.day
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength

TrainingResponses.create
