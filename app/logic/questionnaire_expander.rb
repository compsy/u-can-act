# frozen_string_literal: true

class QuestionnaireExpander
  class << self
    def expand_content(content, response)
      res = []
      content.each do |question|
        new_question = question.deep_dup
        unless new_question[:foreach].present?
          res << new_question
          next
        end
        response.person.my_students.each_with_index do |person, idx|
          # TODO: add case
          tmp_question = new_question.deep_dup
          tmp_question = replace_question(tmp_question, person, idx)
          res << tmp_question
        end
      end
      res
    end

    private

    # TODO: change idx to person id or something
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
      Rails.logger.info question.pretty_inspect
      question[:id] = "#{question[:id]}_#{person.external_identifier}".to_sym
      question
    end

    def test; end
  end
end
