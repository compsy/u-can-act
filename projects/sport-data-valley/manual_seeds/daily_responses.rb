# frozen_string_literal: true

require_relative 'helpers/people_helper'
srand(123)

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
module DailyResponses
  extend PeopleHelper

  START_DATE = 10.weeks.ago.beginning_of_day # rubocop:disable Rails/RelativeDateConstant
  END_DATE = START_DATE + 10.weeks
  N_PARTICIPANTS = 5

  class << self
    def one2five
      scores = (1..5).step(0.5).map(&:to_s)
      scores[rand(scores.count)]
    end

    def sleep_duration
      hours = (4..12).map(&:to_s)
      minutes = (0..59).map(&:to_s)

      [hours[rand(hours.count)], minutes[rand(minutes.count)]]
    end

    def rest_hr
      hrs = (45..70).map(&:to_s)
      hrs[rand(hrs.count)]
    end

    def weight
      ws = (40..100).step(0.5).map(&:to_s)
      ws[rand(ws.count)]
    end

    def yesno
      rand > 0.5 ? 'ja' : 'nee'
    end

    def difficulty
      inj = [
        '0. Volledige deelname zonder gezondheidsproblemen.',
        '1. Volledige deelname, maar met blessure/ziekte',
        '2. Verminderde deelname door blessure/ziekte',
        '3. Kan niet deelnemen door blessure/ziekte'
      ]
      inj[rand(inj.count)]
    end

    def volume
      v = [
        '0. Geen vermindering',
        '1. In geringe mate',
        '2. In gemiddelde mate',
        '3. In grote mate',
        '4. Kan helemaal niet deelnemen (aan training)'
      ]
      v[rand(v.count)]
    end
    
    def performance
      inj = [
        '0. Geen vermindering',
        '1. In geringe mate',
        '2. In gemiddelde mate',
        '3. In grote mate',
        '4. Kan helemaal niet deelnemen (aan training)'
      ]
      inj[rand(inj.count)]
    end
    
    def complaints
      c = [
        '0. Geen symptomen of gezondheidsklachten',
        '1. In geringe mate',
        '2. In gemiddelde mate',
        '3. In grote mate'
      ]
      c[rand(c.count)]
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
      content[:v1] = one2five

      hours, mins = sleep_duration
      content[:v2_uren] = hours
      content[:v2_minuten] = mins

      content[:v3] = one2five
      content[:v4] = one2five
      content[:v5] = one2five
      content[:v6] = one2five
      content[:v7] = one2five
      content[:v8] = rest_hr
      content[:v8a] = weight
      content[:v9] = yesno
      content[:v10] = yesno
      content[:v11] = 'some text'

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

      response_params[:open_from] = timestamp - 1.minute
      response_params[:opened_at] = timestamp
      response_params[:completed_at] = timestamp + 1.minute
      content = {}
      content[:v1] = one2five
      content[:v2] = one2five
      content[:v3] = difficulty
      content[:v4] = volume
      content[:v5] = performance
      content[:v6] = complaints
      content[:v7] = 'some comment'

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
          create_daily_response(person, date)

          date += 1.day
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength

DailyResponses.create
