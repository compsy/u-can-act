# frozen_string_literal: true

class PreviousResponseFinder
  include Prefillable

  class << self
    def find(response)
      return nil if response.blank?
      return nil unless response.measurement.periodical?

      previous_response(response, false)
    end

    def find_value(response, question_id)
      previous_response = find(response)
      return nil if previous_response&.values.blank?

      # The keys of the values of a response are usually strings, but to also
      # support symbols, use with_indifferent_access here.
      previous_response.values.with_indifferent_access[question_id]
    end
  end
end
