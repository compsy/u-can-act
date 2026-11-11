# frozen_string_literal: true

class QuestionnaireExpander
  HTML_KEYS = %i[title content section_start otherwise_label tooltip button_text].freeze
  HTML_LIST_KEYS = %i[options].freeze

  class << self
    def expand_content(content, response, html: false)
      if content.is_a?(Hash)
        if QuestionnaireExpanders::FirstAndLastExpander.needs_expansion? content
          return QuestionnaireExpanders::FirstAndLastExpander.expand!(content, response, html: html)
        end
        return process_foreach(content, response, html) if process_foreach? content, response
        return process_uses(content, response, html) if process_uses? content
      end

      process_normal(content, response, html)
    end

    private

    def process_foreach?(content, response)
      content[:foreach].present? && response.present?
    end

    def process_uses?(content)
      content[:uses].present?
    end

    def process_normal(content, response, html)
      subs_hash = VariableSubstitutor.substitute_variables(response)
      result = VariableEvaluator.evaluate_obj(content, subs_hash, **html_options(html))
      [result]
    end

    def process_uses(content, response, html)
      raise "Uses must be of hash type type, not '#{content[:uses]}'" unless content[:uses].is_a? Hash

      case content[:uses].keys.first
      when :previous
        process_uses_previous(content, response, html)
      else
        raise "Only :previous uses type is allowed, not '#{content[:uses]}'"
      end
    end

    def process_uses_previous(content, response, html)
      question_id = content[:uses][:previous]
      default_value = content[:uses][:default] || ''
      previous_value = PreviousResponseFinder.find_value(response, question_id)

      subs_hash = VariableSubstitutor.substitute_variables(response)
      subs_hash["previous_#{question_id}"] = previous_value || default_value
      [VariableEvaluator.evaluate_obj(content, subs_hash, **html_options(html))]
    end

    def process_foreach(content, response, html)
      case content[:foreach]
      when :student
        mentor = response.person
        mentor.my_students.map do |student|
          content_dup = content.deep_dup
          subs_hash = VariableSubstitutor.create_substitution_hash(mentor, student)
          content_dup[:id] = "#{content_dup[:id]}_#{student.external_identifier}"
          VariableEvaluator.evaluate_obj(content_dup, subs_hash, **html_options(html))
        end
      else
        raise "Only :student foreach type is allowed, not #{content[:foreach]}"
      end
    end

    def html_options(html)
      html ? { html_keys: HTML_KEYS, html_list_keys: HTML_LIST_KEYS } : {}
    end
  end
end
