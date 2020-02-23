# frozen_string_literal: true

class MyRandomResponseError < StandardError
end

class RandomResponseGenerator
  class << self
    include ConversionHelper

    def generate(questionnaire_content)
      @response = {}
      questionnaire_content[:questions].each do |question|
        add_answer_for_question(question)
      end
      @response
    end

    private

    def add_answer_for_question(question)
      return if question[:id].blank?

      answer = generate_answer_for_question(question)
      @response[question[:id].to_s] = (answer.is_a?(String) ? answer : number_to_string(answer))
    rescue MyRandomResponseError
      # This just means the answer won't be added
      nil
    end

    def generate_answer_for_question(question)
      case question[:type]
      when :radio, :likert
        generate_answer_for_radio(question)
      when :range
        generate_answer_for_range(question)
      else
        raise MyRandomResponseError, "Cannot generate answer for question of type #{question[:type]}"
      end
    end

    def generate_answer_for_radio(question)
      cur_titles = titles(question, :options) # check if it's options
      raise "This question does not have any titles: #{question}" if cur_titles.size.zero?

      idx = rand(0...cur_titles.size)
      cur_titles[idx]
    end

    def titles(question, attr)
      titles = []
      question[attr].each do |option|
        title = option
        title = option[:title] if option.is_a?(Hash) && option.key?(:title)
        raise "The following option could not be resolved to a string: #{option}" unless option.is_a?(String)

        titles << title
      end
      titles
    end

    def generate_answer_for_range(question)
      minmax = determine_min_max_step(question)
      rand(minmax[:min]..minmax[:max])
    end

    def determine_min_max_step(_question)
      { min: 0, max: 100, step: 1 }
      # Something with:
      # (question[:min]..question[:max]).step(question[:step]) do |pos|
      #       distribution[qid][number_to_string(pos)] = { VALUE => 0 }
      #     end
      # maybe abstract it to a common function
    end
  end
end
