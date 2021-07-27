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
          number_of_completed_questionnaires: number_of_completed_questionnaires([Person::STUDENT, Person::MENTOR]),
          number_of_book_signups: number_of_book_signups
        }
        render json: data, scope: :current_user
      end

      private

      def number_of_students
        number_of_informed_consents_given(Person::STUDENT)
      end

      def number_of_mentors
        number_of_informed_consents_given(Person::MENTOR)
      end

      def number_of_book_signups
        number_of_completed_responses('boek')
      end

      def duration_of_project_in_weeks
        start, endd = project_start_and_end_dates
        return 0 if endd <= start

        start.step(endd, 7).count
      end

      def project_start_and_end_dates
        start = Date.parse(Rails.application.config.settings.project_start_date)
        endd = [Date.parse(Rails.application.config.settings.project_end_date), Time.zone.today].min
        [start, endd]
      end
    end
  end
end
