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
      # TODO: use RandomAlphaNumericStringGenerator to generate stuff for text fields
      case question[:type]
      when :radio, :likert, :dropdown
        generate_answer_for_radio(question)
      when :checkbox
        generate_answer_for_checkbox(question)
      when :range
        generate_answer_for_range(question)
      when :textfield, :textarea
        generate_answer_for_text(question)
      when :number
        generate_answer_for_number(question)
      else
        raise MyRandomResponseError, "Cannot generate answer for question of type #{question[:type]}"
      end
    end

    def generate_answer_for_radio(question)
      cur_titles = titles(question, :options)
      raise "This question does not have any options: #{question.pretty_inspect}" if cur_titles.size.zero?

      idx = rand(0...cur_titles.size)
      cur_titles[idx]
    end

    def titles(question, attr)
      titles = []
      question[attr].each do |option|
        title = option
        title = option[:title] if option.is_a?(Hash) && option.key?(:title)
        raise "The following option could not be resolved to a string: #{option}" unless title.is_a?(String)

        titles << title
      end
      titles
    end

    def generate_answer_for_text(_question)
      RandomAlphaNumericStringGenerator.generate(rand(20..30))
    end

    def generate_answer_for_range(question)
      minmax = determine_min_max_step(question)
      (minmax[:min]..minmax[:max]).step(minmax[:step]).to_a.sample
    end

    def generate_answer_for_number(question)
      minmax = determine_min_max_step(question)
      rand(minmax[:min]..minmax[:max])
    end

    def determine_min_max_step(question)
      qmin = 0
      qmin = question[:min] if question[:min].present?
      qmax = 100
      qmax = question[:max] if question[:max].present?
      qstep = 1
      qstep = question[:step] if question[:step].present?
      { min: qmin, max: qmax, step: qstep }
    end

    def generate_answer_for_checkbox(question)
      cur_titles = titles(question, :options)
      raise "This question does not have any options: #{question.pretty_inspect}" if cur_titles.size.zero?

      if question[:required].blank? && rand < 1.0 / cur_titles.size
        # don't fill out anything
      else
        nr_checked = rand(1..cur_titles.size)
        cur_titles.shuffle[0...nr_checked].each do |title|
          @response[idify(question[:id], title)] = 'true'
        end
      end
      raise MyRandomResponseError, 'We already added our own responses'
    end

    def idify(*strs)
      strs.map { |x| x.to_s.parameterize.underscore }.join('_')
    end
  end
end
