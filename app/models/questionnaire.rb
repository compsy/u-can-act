# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  KNOWN_OPERATIONS = %i[average].freeze
  KNOWN_PREPROCESSING_STEPS = %i[multiply_with offset].freeze

  validates :name, presence: true, uniqueness: true
  validates :content, presence: true
  validates :key, presence: true, uniqueness: true, format: { with: /\A[a-z]+[a-z_0-9]*\Z/ }
  serialize :content # Don't specify Hash type because otherwise databases with existing questionnaires won't work
  validate :questionnaire_structure, if: -> { content.present? }
  with_options if: :content_has_questions do
    validate :all_questions_have_types
    validate :all_questions_have_titles
    validate :all_questions_have_ids
    validate :all_ranges_have_labels
    validate :all_likert_radio_checkbox_dropdown_have_options
  end
  with_options if: :content_has_scores do
    validate :all_scores_have_required_atributes
    validate :all_scores_have_nonempty_ids
    validate :all_scores_have_known_operations
    validate :all_scores_have_valid_ids_in_preprocessing
    validate :all_scores_have_valid_preprocessing
  end
  with_options if: :content_has_questions_and_scores do
    validate :all_content_ids_unique
    validate :all_scores_use_existing_ids
  end
  has_many :measurements, dependent: :destroy
  has_many :informed_consent_protocols, class_name: 'Protocol', dependent: :nullify,
                                        foreign_key: 'informed_consent_questionnaire_id',
                                        inverse_of: :informed_consent_questionnaire
  has_many :responses, through: :measurements

  scope :pilot, (lambda {
    where('name = :name1 OR name = :name2 OR name = :name3 OR name = :name4 OR ' \
          'name = :name5 OR name = :name6 OR name = :name7 OR name = :name8 OR ' \
          'name = :name9 OR name = :name10 OR name = :name11 OR name = :name12 OR ' \
          'name = :name13 OR name = :name14 OR name = :name15',
          name1: 'dagboek mentoren 1x per week donderdag',
          name2: 'nameting mentoren 1x per week',
          name3: 'informed consent mentoren 1x per week',
          name4: 'dagboek studenten 1x per week donderdag',
          name5: 'nameting studenten 1x per week',
          name6: 'dagboek studenten 2x per week maandag',
          name7: 'nameting studenten 2x per week',
          name8: 'dagboek studenten 5x per week maandag',
          name9: 'nameting studenten 5x per week',
          name10: 'informed consent studenten 1x per week',
          name11: 'informed consent studenten 2x per week',
          name12: 'informed consent studenten 5x per week',
          name13: 'dagboek studenten 2x per week donderdag',
          name14: 'dagboek studenten 5x per week dinsdag, woensdag, vrijdag',
          name15: 'dagboek studenten 5x per week donderdag')
  })

  def drawing_ids
    content[:questions].select { |question| question[:type]&.to_sym == :drawing }.map { |question| question[:id] }
  end

  def recalculate_scores!
    # if there are no completed responses, we don't need to recalculate scores
    return if responses.completed.count.zero?

    RecalculateScoresJob.perform_later(id)
  end

  private

  def questionnaire_structure
    return if content.is_a?(Hash) && content.key?(:scores) && content.key?(:questions) &&
              content[:scores].is_a?(Array) && content[:questions].is_a?(Array)

    errors.add(:content, 'needs to be a Hash with :questions and :scores components')
  end

  def content_has_questions
    content.is_a?(Hash) && content.key?(:questions)
  end

  def content_has_scores
    content.is_a?(Hash) && content.key?(:scores)
  end

  def content_has_questions_and_scores
    content_has_questions && content_has_scores
  end

  def all_content_ids_unique
    question_ids = content[:questions].map { |entry| entry[:id] }
    score_ids = content[:scores].map { |entry| entry[:id] }
    ids = question_ids + score_ids
    result = ids.detect { |entry| ids.count(entry) > 1 }

    return if result.blank?

    errors.add(:content, "can only have a series of unique ids: #{result}")
  end

  def all_questions_have_types
    result = content[:questions].select { |question| question[:type].blank? }.map { |question| question[:id] }
    return if result.blank?

    errors.add(:content, "the following questions are missing the required :type attribute: #{result.pretty_inspect}")
  end

  def all_questions_have_titles
    result = content[:questions].reject { |question| %i[raw unsubscribe].include?(question[:type]&.to_sym) }
                                .reject { |question| question.key?(:title) }
                                .map { |question| question[:id] }
    return if result.blank?

    errors.add(:content, "the following questions are missing the required :title attribute: #{result.pretty_inspect}")
  end

  def all_questions_have_ids
    result = content[:questions].reject { |question| %i[raw unsubscribe].include?(question[:type]&.to_sym) }
                                .reject { |question| question.key?(:id) }
                                .map { |question| question[:title] }
    return if result.blank?

    errors.add(:content, "the following questions are missing the required :id attribute: #{result.pretty_inspect}")
  end

  def all_ranges_have_labels
    result = content[:questions].select { |question| %i[range].include?(question[:type]&.to_sym) }
                                .reject { |question| non_empty_array?(question, :labels) }
                                .map { |question| question[:id] }
    return if result.blank?

    errors.add(:content, 'the following range type questions are missing the required :labels' \
                         " array attribute: #{result.pretty_inspect}")
  end

  def all_likert_radio_checkbox_dropdown_have_options
    options_required_for = %i[checkbox likert radio dropdown]
    result = content[:questions].select { |question| options_required_for.include?(question[:type]&.to_sym) }
                                .reject { |question| non_empty_array?(question, :options) }
                                .map { |question| question[:id] }
    return if result.blank?

    errors.add(:content, 'the following questions are missing their required :options' \
      " array attribute: #{result.pretty_inspect}")
  end

  def non_empty_array?(question, attr)
    question.key?(attr) && question[attr].is_a?(Array) && question[attr].size.positive?
  end

  def all_scores_have_required_atributes
    result = content[:scores]
             .reject { |score| score.key?(:id) && score.key?(:label) && score.key?(:ids) && score.key?(:operation) }
             .map { |score| score[:label] || score[:id] }
    return if result.blank?

    errors.add(:content, "the following scores are missing one or more required attributes: #{result.pretty_inspect}")
  end

  def all_scores_have_nonempty_ids
    result = content[:scores]
             .select { |score| score[:ids].blank? }
             .map { |score| score[:label] || score[:id] }
    return if result.blank?

    errors.add(:content, "the following scores have an empty ids attribute: #{result.pretty_inspect}")
  end

  def all_scores_use_existing_ids
    allowed_ids = content[:questions].map { |entry| entry[:id] }
    result = content[:scores].select do |score|
      is_bad = ((score[:ids] || []) - allowed_ids).size.positive?
      allowed_ids << score[:id]
      is_bad
    end
    result = result.map { |score| score[:label] }
    return if result.blank?

    errors.add(:content, "the following scores use ids that do not exist in their context: #{result.pretty_inspect}")
  end

  def all_scores_have_known_operations
    result = content[:scores]
             .reject { |score| KNOWN_OPERATIONS.include?(score[:operation]) }
             .map { |score| score[:label] || score[:id] }
    return if result.blank?

    errors.add(:content, "the following scores have an unknown operation: #{result.pretty_inspect}")
  end

  def all_scores_have_valid_ids_in_preprocessing
    result = content[:scores]
             .select { |score| score.key?(:preprocessing) }
             .select { |score| (score[:preprocessing].keys - (score[:ids] || [])).present? }
             .map { |score| score[:label] || score[:id] }
    return if result.blank?

    errors.add(:content, "the following scores have invalid ids in preprocessing steps: #{result.pretty_inspect}")
  end

  def all_scores_have_valid_preprocessing
    result = content[:scores]
             .select { |score| score.key?(:preprocessing) }
             .select { |score| invalid_preprocessing_steps?(score[:preprocessing]) }
             .map { |score| score[:label] || score[:id] }
    return if result.blank?

    errors.add(:content, "the following scores have invalid preprocessing steps: #{result.pretty_inspect}")
  end

  def invalid_preprocessing_steps?(score_preprocessing)
    (score_preprocessing.values.map(&:keys).flatten.uniq.map(&:to_sym) - KNOWN_PREPROCESSING_STEPS).present?
  end
end
