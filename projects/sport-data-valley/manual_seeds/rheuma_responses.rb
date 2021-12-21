# frozen_string_literal: true

require_relative 'helpers/people_helper'

srand(123)

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
class RheumaResponses
  extend PeopleHelper

  START_DATE = 3.weeks.ago.beginning_of_day # rubocop:disable Rails/RelativeDateConstant
  END_DATE = START_DATE + 3.weeks
  N_PARTICIPANTS = 5

  class << self
    def range0to10
      rand(0.0..10.0).round(1).to_s
    end

    # Returns a value in between 0 and 24 in increments of 0.5
    def n_hours
      hours = rand((24 * 2) + 1)
      hours * 0.5
    end

    def create_rheuma_responses(person, date)
      return if rand > 0.9

      protocol_name = 'daily_protocol_rheumatism'
      puts "Creating responses for #{protocol_name}"
      protocol = Protocol.find_by(name: protocol_name)
      raise "Error: protocol named #{protocol_name} not found" unless protocol

      protsub = ProtocolSubscription.find_by(person: person, protocol: protocol)
      protsub ||= ProtocolSubscription.new(person: person, protocol: protocol)

      protsub.state = ProtocolSubscription::COMPLETED_STATE
      protsub.start_date = Time.new(2016).in_time_zone
      protsub.end_date = Time.new(2017).in_time_zone
      protsub.save!

      questionnaire_key = 'daily_questionnaire_rheumatism'
      questionnaire_id = Questionnaire.find_by(key: questionnaire_key).id
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

      response_params[:open_from] = date - 1.minute
      response_params[:opened_at] = date
      response_params[:completed_at] = date + 1.minute

      content = {}
      content[:v1] = range0to10
      content[:v2] = rand > 0.5 ? 'Ja' : 'Nee'
      content[:v2_ja_br_zo_ja_waar_denkt_u_dat_dit_door_kwam_text] = 'geen idee' if content[:v2] == 'Ja'
      content[:v3] = range0to10
      content[:v4] = range0to10
      content[:v5] = n_hours
      content[:v6] = n_hours
      content[:v7] = n_hours
      content[:v8] = n_hours

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
          create_rheuma_responses(person, date)

          date += 1.day
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength

RheumaResponses.create
