# frozen_string_literal: true

class MyMissingDataError < StandardError
end

# Calculate scores given the content of a completed response and its questionnaire definition
class CalculateScores < ActiveInteraction::Base
  include ConversionHelper
  hash :content, strip: false # strip: false means allow all keys
  hash :questionnaire, strip: false

  # Enriches the questionnaire outcomes with scores
  #
  # @param content [Hash] the response values as a hash (keys are strings)
  # @param questionnaire [Hash] the questionnaire definition hash (keys can be symbols)
  def execute
    @scores = {}
    # Do the translation of the labels and titles so that we have the default language options remaining
    @questionnaire_content = QuestionnaireTranslator.translate_content(questionnaire.deep_dup, 'i18n')
    @questionnaire_content = QuestionnaireTranslator.translate_content(
      @questionnaire_content,
      Rails.application.config.i18n.default_locale.to_s
    )

    @questionnaire_content[:scores].each do |score|
      calculate_and_add_score(score)
    end
    @scores
  end

  private

  def to_number(value, qids)
    return nil if value.blank?

    my_value = possibly_substitute_for_number(value, qids)
    # my_value can be either a string or a number (float or int) at this point.
    str_or_num_to_num(my_value)
  end

  # This method substitutes the given string value for a number if this substitution
  # was defined in the questionnaire.
  #
  # If the value of a question in the response content hash belongs to a question
  # that has an options attribute, and the value is one of the options, then
  # check if this option has the `numeric_value` attribute, and if so, return
  # this numeric_value. Otherwise, return the guveb value unchanged.
  def possibly_substitute_for_number(value, qids)
    question = @questionnaire_content[:questions].find { |quest| quest[:id] == qids.to_sym }
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
    @scores[score[:id].to_s] = value.to_s
  rescue MyMissingDataError
    # This just means the score won't be calculated
    nil
  end

  def calculate_score(score)
    data = gather_data(score)
    value = perform_operation(data, score)
    round_result(value, score)
  end

  def read_from_content(qids)
    return content[qids] if content.key?(qids) && content[qids].present?

    @scores[qids]
  end

  def exists_in_content?(qids)
    (content.key?(qids) && content[qids].present?) ||
      (@scores.key?(qids) && @scores[qids].present?)
  end

  def gather_data(score)
    result = []
    score[:ids].each do |qid|
      qids = qid.to_s
      unless exists_in_content?(qids)
        raise MyMissingDataError, "id #{qids} not found in the enriched response" if score[:require_all].present?

        next
      end
      numeric_value = to_number(read_from_content(qids), qids)
      if numeric_value.blank?
        raise MyMissingDataError, "no numeric value for #{qids} could be determined" if score[:require_all].present?

        next
      end
      numeric_value = preprocess_value(numeric_value, qid, score) if numeric_value.present?
      result << numeric_value
    end
    result
  end

  def perform_operation(data, score)
    case score[:operation]
    when :average
      perform_operation_average(data)
    when :sum
      perform_operation_sum(data)
    else
      raise "unknown operation: #{score[:operation]}"
    end
  end

  def perform_operation_average(data)
    raise MyMissingDataError, 'trying to calculate the average of an empty array' if data.size.zero?
    return data[0] if data.size == 1 # no need to convert to float if we have just one integer

    data.sum(0.0) / data.size
  end

  def perform_operation_sum(data)
    raise MyMissingDataError, 'trying to calculate the sum of an empty array' if data.size.zero?
    return data[0] if data.size == 1 # no need to convert to float if we have just one integer

    data.sum(0)
  end

  def round_result(value, score)
    return value unless score.key?(:round_to_decimals)

    value.round(score[:round_to_decimals])
  end

  def preprocess_value(numeric_value, qid, score)
    return numeric_value unless score.key?(:preprocessing) && score[:preprocessing].key?(qid)

    preprocessing_step = score[:preprocessing][qid]
    Questionnaire::PREPROCESSING_STEPS.each do |step|
      next unless preprocessing_step.key?(step[:name])

      numeric_value = numeric_value.send(step[:method], str_or_num_to_num(preprocessing_step[step[:name]]))
    end
    numeric_value
  end
end
