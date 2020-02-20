# frozen_string_literal: true

require 'csv'

class QuestionnaireExporter
  extend Exporters
  class << self
    def export_lines(questionnaire_name)
      questionnaire = Questionnaire.find_by(name: questionnaire_name)
      raise 'Questionnaire not found' unless questionnaire

      questionnaire_content = questionnaire.content
      @counter = 0
      Enumerator.new do |enum|
        export_questionnaire(questionnaire_content) do |line|
          enum << line + "\n"
        end
      end
    end

    private

    def export_questionnaire(questionnaire_content, &block)
      fields = %w[type hidden section_start section_end title placeholder tooltip required content] +
               %w[labels label options show_otherwise otherwise_label otherwise_tooltip today min max step width] +
               %w[hours_from hours_to hours_step data_method unsubscribe_url combines_with] +
               %w[height image color maxlength links_to_expandable default_value pattern hint] +
               %w[radius density button_text show_after ids operation require_all round_to_decimals]
      headers = %w[question_id question_position] + fields
      yield format_headers(headers)
      questionnaire_content[:questions].each do |question|
        next export_question(question, headers, fields, &block) if question[:type] != :expandable

        question[:content].each { |sub_question| export_question(sub_question, headers, fields, &block) }
      end
      questionnaire_content[:scores].each do |score|
        export_question(score, headers, fields, &block)
      end
    end

    def export_question(question, headers, fields)
      vals = special_fields(question)
      fields.each do |field|
        vals[field] = question[field.to_sym]
      end
      yield format_hash(headers, vals)
    end

    def special_fields(question)
      # set question_id question_number labels options
      @counter += 1
      {
        'question_id' => question[:id],
        'question_position' => @counter
      }
    end
  end
end
