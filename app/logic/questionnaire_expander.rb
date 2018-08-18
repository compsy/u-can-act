# frozen_string_literal: true

class QuestionnaireExpander
  class << self
    def expand_content(content, response)
      if content.is_a?(Hash)
        return process_foreach(content, response) if content[:foreach].present?
        return process_uses(content, response) if content[:uses].present?
      end

      process_normal(content, response)
    end

    private

    def process_normal(content, response)
      subs_hash = VariableSubstitutor.substitute_variables(response)
      result = VariableEvaluator.evaluate_obj(content, subs_hash)
      [result]
    end

    def process_uses(content, response)
      raise "Uses must be of hash type type, not '#{content[:uses]}'" unless content[:uses].is_a? Hash

      case content[:uses].keys.first
      when :previous
        process_uses_previous(content, response)
      else
        raise "Only :previous uses type is allowed, not '#{content[:uses]}'"
      end
    end

    def process_uses_previous(content, response)
      question_id = content[:uses][:previous]
      default_value = content[:uses][:default]
      previous_value = PreviousResponseFinder.find_value(response, question_id)
      subs_hash = VariableSubstitutor.substitute_variables(response)
      subs_hash["previous_#{question_id}"] = previous_value || default_value
      [VariableEvaluator.evaluate_obj(content, subs_hash)]
    end

    def process_foreach(content, response)
      case content[:foreach]
      when :student
        mentor = response.person
        mentor.my_students.map do |student|
          content_dup = content.deep_dup
          subs_hash = VariableSubstitutor.create_substitution_hash(mentor, student)
          content_dup[:id] = "#{content_dup[:id]}_#{student.external_identifier}"
          VariableEvaluator.evaluate_obj(content_dup, subs_hash)
        end
      else
        raise "Only :student foreach type is allowed, not #{content[:foreach]}"
      end
    end
  end
end
