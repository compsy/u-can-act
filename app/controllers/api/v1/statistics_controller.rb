# frozen_string_literal: true

module Api
  module V1
    class StatisticsController < ApiController
      include StatisticsHelper
      def index
        data = {
          number_of_students: number_of_students,
          number_of_mentors: number_of_mentors,
          duration_of_project_in_weeks: duration_of_project_in_weeks,
          number_of_completed_questionnaires: number_of_completed_questionnaires
        }
        render json: data
      end

      private

      def number_of_students
        number_of_informed_consents_given(Person::STUDENT)
      end

      def number_of_mentors
        number_of_informed_consents_given(Person::MENTOR)
      end

      def duration_of_project_in_weeks
        start = Date.parse(ENV['PROJECT_START_DATE'])
        endd = [Date.parse(ENV['PROJECT_END_DATE']), Date.today].min
        return 0 if endd <= start

        start.step(endd, 7).count
      end

      def number_of_completed_questionnaires
        measurement_ids = student_and_mentor_protocol_names.map do |protocol_name|
          Protocol.find_by_name(protocol_name)&.measurements&.map(&:id)
        end.flatten.uniq.compact
        return 0 if measurement_ids.blank?

        Response.completed.where(measurement_id: measurement_ids).count
      end

      def student_and_mentor_protocol_names
        (Rails.application.config.settings.protocol_names&.student || []) +
          (Rails.application.config.settings.protocol_names&.mentor || [])
      end
    end
  end
end
