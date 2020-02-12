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

  def to_number(value, qids)
    return nil if value.blank?

    my_value = determine_numeric_value(value, qids)
    # if we are a string that can't be converted to a number,
    # return nil so we are registered as a missing value
    return nil if my_value.is_a?(String) && (my_value =~ /\A-?\.?[0-9]/).blank?

    (my_value.to_f % 1).positive? ? my_value.to_f : my_value.to_i
  end

  def determine_numeric_value(value, qids)
    question = @questionnaire[:questions].find { |quest| quest[:id] == qids.to_sym }
    return value unless question.present? && question.key?(:options)

    unified_options = unify_options(question[:options])
    current_option = unified_options.find { |option| option[:title] == value }
    return value unless current_option.present? && current_option.key?(:numeric_value)

    current_option[:numeric_value]
  end

  def unify_options(question_options)
    roptions = []
    question_options.each do |question_option|
      roptions << if question_option.is_a?(Hash)
                    question_option
                  else
                    { title: question_option }
                  end
    end
    roptions
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
      unless @enriched_content.key?(qids) && @enriched_content[qids].present?
        raise EnrichMissingDataError, "id #{qids} not found in the enriched response" if score[:require_all].present?

        next
      end
      numeric_value = to_number(@enriched_content[qids], qids)
      if numeric_value.blank?
        raise EnrichMissingDataError, "no numeric value for #{qids} could be determined" if score[:require_all].present?

        next
      end
      result << numeric_value
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
