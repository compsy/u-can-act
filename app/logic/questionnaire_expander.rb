# frozen_string_literal: true

class QuestionnaireExpander
  class << self
    def expand_content(content, response)
      raise unless content.is_a? Array
      content.reduce([]) do |total, question|
        total.concat(question[:foreach].present? ? process_foreach(question, response) : [question])
      end
    end

    private

    def process_foreach(question, response)
      res = []
      case question[:foreach]
      when :student
        response.person.my_students.each_with_index do |person, idx|
          res << replace_question(question.deep_dup, person, idx)
        end
      else
        raise "Foreach option #{question[:foreach]} not found"
      end
      res
    end

    # TODO: We'd probably want to change idx to an actual identifier
    def replace_question(question, person, idx)
      question = replace_student_names(question, idx)
      question = replace_student_zijn_haar(question, idx)
      question = replace_student_hij_zij(question, idx)
      question = replace_student_hem_haar(question, idx)
      question = replace_id(question, person)
      question
    end

    def replace_student_names(question, idx)
      question[:title] = question[:title].gsub('{{naam_studenten}}',
                                               "{{student_#{idx}}}")
      question
    end

    def replace_student_zijn_haar(question, idx)
      question[:title] = question[:title].gsub('{{zijn_haar_studenten}}',
                                               "{{zijn_haar_student_#{idx}}}")
      question
    end

    def replace_student_hij_zij(question, idx)
      question[:title] = question[:title].gsub('{{hij_zij_studenten}}',
                                               "{{hij_zij_student_#{idx}}}")
      question
    end

    def replace_student_hem_haar(question, idx)
      question[:title] = question[:title].gsub('{{hem_haar_studenten}}',
                                               "{{hem_haar_student_#{idx}}}")
      question
    end

    def replace_id(question, person)
      # TODO: Should this be some kind of bubblebabble?
      question[:id] = "#{question[:id]}_#{person.external_identifier}".to_sym
      question
    end

    def test; end
  end
end
