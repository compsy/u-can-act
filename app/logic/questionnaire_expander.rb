# frozen_string_literal: true

class QuestionnaireExpander
  class << self
    def expand_content(content, response)
      if content.is_a?(Hash)
        return process_first_response(content, response) if process_first_response? content
        return process_foreach(content, response) if process_foreach? content
        return process_uses(content, response) if process_uses? content
      end

      process_normal(content, response)
    end

    private

    def process_foreach?(content)
      content[:foreach].present? && response.present?
    end

    def process_uses?(content)
      content[:uses].present?
    end

    def process_first_response?(content)
      content[:title].is_a?(Hash) || content[:content].is_a?(Hash)
    end

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

    def process_first_response(content, response)
      items = %i[title content]
      items.each do |key|
        # Just quit searching if we do not have any more tags to replace.
        break unless process_first_response? content

        next unless content[key].is_a? Hash

        previous = PreviousResponseFinder.find(response)

        initial_value = content[key][:first]
        content[key] = if previous.blank? && initial_value.present?
                         initial_value
                       else
                         content[key][:normal]
                       end
      end
      expand_content(content, response)
    end

    def process_uses_previous(content, response)
      question_id = content[:uses][:previous]
      default_value = content[:uses][:default] || ''
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
