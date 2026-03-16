# frozen_string_literal: true

require_relative '../protocol_helper'

def create_or_update_rheumatism_standalone_protocol(protocol_name)
  protocol = create_or_update_protocol(protocol_name, 1.week)
  push_subscription_name = "base-platform-subscription-#{protocol_name.tr('_', '-')}"
  add_push_subscription(protocol, push_subscription_name)

  questionnaire = Questionnaire.find_by(key: protocol_name)
  raise "questionnaire #{protocol_name} not found" unless questionnaire

  measurement = protocol.measurements.find_by(questionnaire_id: questionnaire.id)
  measurement ||= protocol.measurements.build(questionnaire_id: questionnaire.id)
  measurement.open_from_offset = 0
  measurement.open_from_day = nil
  measurement.period = nil
  measurement.open_duration = nil
  measurement.reminder_delay = 24.hours
  measurement.priority = 1
  measurement.stop_measurement = true
  measurement.should_invite = true
  measurement.redirect_url = ENV.fetch('BASE_PLATFORM_URL', nil)
  measurement.only_redirect_if_nothing_else_ready = true
  measurement.save!

  protocol.measurements.where.not(id: measurement.id).destroy_all
end
