# frozen_string_literal: true

module Api
  module V1
    class StatisticsController < ApiController
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
        # The same as:
        # Role.where(group: Person::STUDENT).map{|x| x.people ? x.people : nil}.flatten.compact.count,
        Role.joins(:people).where(group: Person::STUDENT).count
      end

      def number_of_mentors
        # The same as:
        # Role.where(group: Person::MENTOR).map{|x| x.people ? x.people : nil}.flatten.compact.count
        Role.joins(:people).where(group: Person::MENTOR).count
      end

      def duration_of_project_in_weeks
        start = ENV['PROJECT_START_DATE']
        Date.parse(start).step(Date.today, 7).count
      end

      def number_of_completed_questionnaires
        Response.completed.count
      end
    end
  end
end
