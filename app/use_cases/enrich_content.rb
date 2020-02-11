# frozen_string_literal: true

# Enrich response content (= questionnaire answers) with scores
class EnrichContent < ActiveInteraction::Base
  EnrichMissingDataError = Class.new(StandardError)

  hash :content, strip: false # strip: false means allow all keys
  hash :questionnaire, strip: false

  # Enriches the questionnaire outcomes with scores
  #
  # @param content [Hash] the response values as a hash (keys are strings)
  # @param questionnaire [Hash] the questionnaire definition hash (keys can be symbols)
  def execute
    @questionnaire = questionnaire # work with instance variables instead of activeinteraction methods
    @enriched_content = content.deep_dup
    @questionnaire[:scores].each do |score|
      calculate_and_add_score(score)
    end
    @enriched_content
  end

  private

  def to_number(value)
    return if value.blank?

    (value.to_f % 1).positive? ? value.to_f : value.to_i
  end

  def calculate_and_add_score(score)
    value = calculate_score(score)
    @enriched_content[score[:id].to_s] = value.to_s
  rescue EnrichMissingDataError
    # This just means the score won't be calculated
    nil
  end

  def calculate_score(score)
    data = gather_data(score)
    value = perform_operation(data, score)
    round_result(value, score)
  end

  def gather_data(score)
    result = []
    score[:ids].each do |qid|
      qids = qid.to_s
      unless @enriched_content.key?(qids)
        raise EnrichMissingDataError, "id #{qids} not found in the enriched response" if score[:require_all].present?

        next
      end
      result << to_number(@enriched_content[qids])
    end
    result
  end

  def perform_operation(data, score)
    case score[:operation]
    when :average
      perform_operation_average(data)
    else
      raise "unknown operation: #{score[:operation]}"
    end
  end

  def perform_operation_average(data)
    raise EnrichMissingDataError, 'trying to calculate the average of an empty array' if data.size.zero?
    return data[0] if data.size == 1 # no need to convert to float if we have just one integer

    data.inject(0.0) { |sum, el| sum + el } / data.size
  end

  def round_result(value, score)
    return value unless score.key?(:round_to_decimals)

    value.round(score[:round_to_decimals])
  end
end
