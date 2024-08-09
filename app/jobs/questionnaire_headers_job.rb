# frozen_string_literal: true

class QuestionnaireHeadersJob < ApplicationJob
  queue_as :default

  def perform
    Questionnaire.find_each do |questionnaire|
      ResponseExporter.export_headers(questionnaire, bust_cache: true)
      Rails.logger.info "Calculated headers for questionnaire: #{questionnaire.key}"
    end
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
