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
      # The following types are currently unsupported (no answers will be generated for them):
      # :drawing, :time, :expandable
      # The question types :raw and :unsubscribe never generate answers in a response, so they are supported.
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
      when :date
        generate_answer_for_date(question)
      else
        raise MyRandomResponseError, "Cannot generate answer for question of type #{question[:type]}"
      end
    end

    def generate_answer_for_radio(question)
      cur_titles = titles(question, :options)
      raise "This question does not have any options: #{question.pretty_inspect}" if cur_titles.empty?

      idx = rand(0...cur_titles.size)
      cur_titles[idx]
    end

    def generate_answer_for_text(_question)
      RandomStringGenerator.generate_alphabetical(rand(5..30))
    end

    def generate_answer_for_range(question)
      minmax = determine_min_max_step(question)
      number_to_string((minmax[:min]..minmax[:max]).step(BigDecimal(minmax[:step].to_s)).to_a.sample)
    end

    def generate_answer_for_number(question)
      minmax = determine_min_max_step(question)
      rand(minmax[:min]..minmax[:max])
    end

    def generate_answer_for_date(question)
      minmax = determine_min_max_date(question)
      rand(minmax[:min]..minmax[:max]).to_formatted_s(:db)
    end

    def determine_min_max_date(question)
      qmin = Time.zone.today
      qmin = Date.parse(question[:min]) if question[:min].present?
      qmax = qmin
      qmax = Date.parse(question[:max]) if question[:max].present?
      { min: qmin, max: qmax }
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
      raise "This question does not have any options: #{question.pretty_inspect}" if cur_titles.empty?

      if question[:required].blank? && rand < 1.0 / cur_titles.size
        # don't fill out anything
      else
        check_random_amount_of_checkbox_options(question, cur_titles)
      end
      raise MyRandomResponseError, 'We already added our own responses'
    end

    def check_random_amount_of_checkbox_options(question, cur_titles)
      nr_checked = rand(1..cur_titles.size)
      cur_titles.shuffle[0...nr_checked].each do |title|
        @response[idify(question[:id], title)] = 'true'
      end
    end
  end
end
