# frozen_string_literal: true

class RecalculateScoresJob < ApplicationJob
  queue_as :default

  def perform(questionnaire_id)
    questionnaire = Questionnaire.find(questionnaire_id)
    return if questionnaire.blank?

    RecalculateScores.run!(questionnaire: questionnaire)
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 5.minutes
  end
end
