# frozen_string_literal: true

require 'csv'

class QuestionnaireExporter
  extend Exporters
  class << self
    def export_lines(questionnaire_name)
      questionnaire = Questionnaire.find_by_name(questionnaire_name)
      raise 'Questionnaire not found' unless questionnaire
      questionnaire_content = questionnaire.content
      @counter = 0
      Enumerator.new do |enum|
        export(questionnaire_content) do |line|
          enum << line + "\n"
        end
      end
    end

    private

    def export(questionnaire_content, &_block)
      fields = %w[type hidden section_start section_end title content labels options otherwise_label min max]
      headers = %w[question_id question_position type hidden section_start section_end] +
                %w[title content labels options otherwise_label min max]
      yield format_headers(headers)
      questionnaire_content.each do |question|
        vals = special_fields(question)
        fields.each do |field|
          vals[field] = question[field.to_sym]
        end
        yield format_hash(headers, vals)
      end
    end

    def special_fields(question)
      # set question_id question_number labels options
      @counter += 1
      {
        'question_id' => question[:id],
        'question_position' => @@counter
      }
    end
  end
end
