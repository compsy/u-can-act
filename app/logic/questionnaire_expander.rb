# frozen_string_literal: true

class QuestionnaireExpander
  class << self
    def expand_content(content, response)
      if content.is_a? Hash
        return process_foreach(content, response) if content[:foreach].present?
      end

      process_normal(content, response)
    end

    private

    def process_normal(content, response)
      subs_hash = VariableSubstitutor.substitute_variables(response)
      result = VariableEvaluator.evaluate_obj(content, subs_hash)
      [result]
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
