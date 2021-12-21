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

    def get_day(date)
      weekdays = %w[
        maandag
        dinsdag
        woensdag
        donderdag
        vrijdag
        zaterdag
        zondag
      ]
      weekdays[date.wday]
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

      Response.where(protocol_subscription_id: protsub_id, measurement_id: measurement_id).each do |response|
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

    def create_daily_response(person, timestamp)
      protocol_name = 'daily_protocol'
      puts "Creating responses for #{protocol_name}"

      protocol = Protocol.find_by(name: protocol_name)
      raise "Error: protocol named #{protocol_name} not found" unless protocol

      protsub = ProtocolSubscription.find_by(person: person, protocol: protocol)
      protsub ||= ProtocolSubscription.new(person: person, protocol: protocol)

      protsub.state = ProtocolSubscription::COMPLETED_STATE
      protsub.start_date = Time.new(2016).in_time_zone
      protsub.end_date = Time.new(2017).in_time_zone
      protsub.save!

      protsub_id = protsub.id
      filled_out_by_id = protsub.person.id
      filled_out_for_id = protsub.filling_out_for.id

      Response.where(protocol_subscription_id: protsub_id).each do |response|
        ResponseContent.find(response.content).destroy if response.content.present?
        response.destroy
      end

      dag = get_day(timestamp)
      questionnaire_name = "daily_questionnaire_#{dag}"
      questionnaire_id = Questionnaire.find_by(name: questionnaire_name).id
      measurement = protocol.measurements.where(questionnaire_id: questionnaire_id).first
      measurement_id = measurement.id

      response_params = {}
      response_params[:protocol_subscription_id] = protsub_id
      response_params[:measurement_id] = measurement_id
      response_params[:filled_out_by_id] = filled_out_by_id
      response_params[:filled_out_for_id] = filled_out_for_id

      response_params[:open_from] = timestamp - 1.minute
      response_params[:opened_at] = timestamp
      response_params[:completed_at] = timestamp + 1.minute

      content = {}
      date = timestamp
      content[:date_dontuse] = date_format(date) # store this somewhere in case we need it later
      content[:v1] = convert_scale_value(row['Sleep quality'])

      content[:v2_uren] = convert_sleep_duration_hours(row['Sleep duration (hours)'])
      content[:v2_minuten] = convert_sleep_duration_minutes(row['Sleep duration (hours)'])
      content[:v2_dontuse] = row['Sleep quality'].tr(',', '.')

      content[:v3] = convert_scale_value(row['Fatigue'])
      content[:v4] = convert_scale_value(row['Stress ']) # Note the space at the end of the attribute name
      content[:v5] = convert_scale_value(row['General muscle soreness'])
      content[:v6] = convert_scale_value(row['Mood'])
      content[:v7] = convert_scale_value(row['Readiness-to-train'])
      content[:v8] = row['Resting HR (bpm)']
      content[:v9] = convert_yes_no(row['Sick?'])
      content[:v10] = convert_yes_no(row['Injured?'])
      content[:v11] = convert_comments(row['Comments'])

      response_content = ResponseContent.create_with_scores!(
        content: content,
        response: Response.new(measurement_id: response_params[:measurement_id])
      )
      response_params[:content] = response_content.id

      PushSubscriptionsJob.perform_later(Response.create!(response_params))

      return unless dag == 'zondag'

      questionnaire_name = 'sunday_questionnaire'

      puts "Creating responses for #{questionnaire_name}"

      questionnaire_id = Questionnaire.find_by(name: questionnaire_name).id
      measurement = protocol.measurements.where(questionnaire_id: questionnaire_id).first
      measurement_id = measurement.id

      response_params = {}
      response_params[:protocol_subscription_id] = protsub_id
      response_params[:measurement_id] = measurement_id
      response_params[:filled_out_by_id] = filled_out_by_id
      response_params[:filled_out_for_id] = filled_out_for_id

      timestamp = Time.zone.strptime(row['Timestamp'], '%m-%d-%Y %H:%M:%S') + TIME_OFFSET
      response_params[:open_from] = timestamp
      response_params[:opened_at] = timestamp
      response_params[:completed_at] = timestamp
      content = {}
      date = Time.zone.strptime(row['Date'], '%m-%d-%Y %H:%M:%S') + TIME_OFFSET
      content[:date_dontuse] = date_format(date) # store this somewhere in case we need it later
      content[:v1] = convert_scale_value(row['Fatigue (mental)'])
      content[:v2] = convert_scale_value(row['Fatigue (physical)'])
      content[:v3] = convert_numerical_radio_blessures(
        row['Difficulties participating due to injury, illness or other health problems?']
      )
      content[:v4] = convert_numerical_radio_training_volume(
        row['Reduced training volume due to injury, illness or other health problems?']
      )
      content[:v5] =
        convert_numerical_radio_prestatie(row['Did injury, illness or other health problems affect your performance?'])
      content[:v6] = convert_numerical_radio_symptoms(row['Did you experience symptoms/health complaints?'])
      content[:v7] = convert_comments(row['How did you experience last week?'])

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
