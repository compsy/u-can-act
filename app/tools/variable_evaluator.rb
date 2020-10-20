# frozen_string_literal: true

class VariableEvaluator
  class << self
    def evaluate_obj(obj, subs_hash)
      return evaluate(obj, subs_hash) if obj.is_a?(String)

      if obj.is_a?(Hash)
        obj.each do |k, v|
          obj[k] = evaluate_obj(v, subs_hash)
        end
        return obj
      end

      if obj.is_a?(Array)
        obj.each_with_index do |v, i|
          obj[i] = evaluate_obj(v, subs_hash)
        end
      end
      obj
    end

    private

    def evaluate(text, subs_hash)
      full_subs_hash = merge(default_subs_hash, subs_hash)
      substitutions_hash = substitutions(full_subs_hash)

      substitutions_hash = merge_string_items(substitutions_hash, subs_hash)

      substitutions_hash.each do |variable, expansion|
        text = perform_static_substitution(text, variable, expansion)
      end
      text
    end

    def merge_string_items(default, extra)
      extra.each_key do |key|
        default[key] = extra[key] if key.is_a? String
      end
      default
    end

    def merge(default, extra)
      default.dup.merge(extra.dup) do |_, oldval, newval|
        newval.presence || oldval
      end
    end

    def perform_static_substitution(text, variable, expansion)
      text = text.gsub("{{#{variable}}}", expansion)
      # if it already starts with a capital, don't capitalize() it, otherwise
      # a name like Jan-Willem will be changed to Jan-willem.
      return text.gsub("{{#{variable.capitalize}}}", expansion) if expansion.match?(/^[A-Z]/)

      text.gsub("{{#{variable.capitalize}}}", expansion.capitalize)
    end

    def default_subs_hash
      {
        mentor_title: 'begeleider',
        mentor_gender: nil,
        mentor_name: 'je begeleider',
        mentor_last_name: '',
        organization: 'je begeleidingsinitiatief',
        student_name: 'deze student', # incl. "deze" want naam ipv titel
        student_last_name: '',
        student_gender: nil
      }
    end

    # rubocop:disable Metrics/AbcSize
    # Ik vind het duidelijker om dit volledig uit te schrijven dan dit te gaan opsplitsen.
    def substitutions(subs_hash)
      {
        'begeleider' => subs_hash[:mentor_title],
        'zijn_haar_begeleider' => possessive_determiner(subs_hash[:mentor_gender]),
        'hij_zij_begeleider' => personal_pronoun(subs_hash[:mentor_gender]),
        'hem_haar_begeleider' => personal_pronoun_dativus(subs_hash[:mentor_gender]),
        'naam_begeleider' => subs_hash[:mentor_name],
        'achternaam_begeleider' => subs_hash[:mentor_last_name],
        'je_begeleidingsinitiatief' => subs_hash[:organization],
        'deze_student' => subs_hash[:student_name],
        'achternaam_student' => subs_hash[:student_last_name],
        'datum_lang' => I18n.l(Time.zone.today, format: :long),
        'datum' => I18n.l(Time.zone.today),
        'zijn_haar_student' => possessive_determiner(subs_hash[:student_gender]),
        'hij_zij_student' => personal_pronoun(subs_hash[:student_gender]),
        'hem_haar_student' => personal_pronoun_dativus(subs_hash[:student_gender])
      }
    end
    # rubocop:enable Metrics/AbcSize

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

    def personal_pronoun_dativus(gender)
      case gender
      when Person::FEMALE
        'haar'
      when Person::MALE
        'hem'
      else
        'hem/haar'
      end
    end
  end
end
