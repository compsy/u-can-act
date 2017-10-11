# frozen_string_literal: true

class VariableEvaluator
  class << self
    def evaluate_obj(obj, mentor_title = 'begeleider', mentor_gender = nil,
                     student_name = 'deze student', student_gender = nil)
      if obj.is_a?(String)
        return evaluate(obj, mentor_title, mentor_gender,
                        student_name, student_gender)
      elsif obj.is_a?(Hash)
        obj.each do |k, v|
          obj[k] = evaluate_obj(v, mentor_title, mentor_gender,
                                student_name, student_gender)
        end
      elsif obj.is_a?(Array)
        obj.each_with_index do |v, i|
          obj[i] = evaluate_obj(v, mentor_title, mentor_gender,
                                student_name, student_gender)
        end
      end
      obj
    end

    private

    def evaluate(text, mentor_title = 'begeleider', mentor_gender = nil,
                 student_name = 'deze student', student_gender = nil)
      mentor_title = 'begeleider' if mentor_title.blank?
      substitutions = {
        'begeleider' => mentor_title,
        'zijn_haar_begeleider' => possessive_determiner(mentor_gender),
        'hij_zij_begeleider' => personal_pronoun(mentor_gender),
        'deze_student' => student_name, # incl. "deze" want naam ipv titel
        'zijn_haar_student' => possessive_determiner(student_gender),
        'hij_zij_student' => personal_pronoun(student_gender)
      }
      substitutions.each do |variable, expansion|
        text = text.gsub("{{#{variable}}}", expansion)
        # if it already starts with a capital, don't capitalize() it, otherwise
        # a name like Jan-Willem will be changed to Jan-willem.
        text = if expansion.match?(/^[A-Z]/)
                 text.gsub("{{#{variable.capitalize}}}", expansion)
               else
                 text.gsub("{{#{variable.capitalize}}}", expansion.capitalize)
               end
      end
      text
    end

    def possessive_determiner(gender)
      case gender
      when Person::FEMALE
        'haar'
      when Person::MALE
        'zijn'
      else
        'zijn/haar'
      end
    end

    def personal_pronoun(gender)
      case gender
      when Person::FEMALE
        'zij'
      when Person::MALE
        'hij'
      else
        'hij/zij'
      end
    end
  end
end
