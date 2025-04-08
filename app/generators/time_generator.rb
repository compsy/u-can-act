# frozen_string_literal: true

class TimeGenerator < QuestionTypeGenerator
  include ConversionHelper

  def generate(question)
    body = time_body(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([tag.p(title, class: 'flow-text'), body])
  end

  private

  # rubocop:disable Metrics/PerceivedComplexity
  def time_body(question)
    from = question[:hours_from] || 0
    to = question[:hours_to] || 6
    step = question[:hours_step] || 1
    hours_label = question[:hours_label] || 'Uren'
    raw_hours_label = question[:raw][:hours_label] || 'Uren'
    minutes_label = question[:minutes_label] || 'Minuten'
    raw_minutes_label = question[:raw][:minutes_label] || 'Minuten'
    am_pm = question[:am_pm] || false

    hours = time_dropdown(question[:id], from, to, step, hours_label, raw_hours_label, am_pm)
    minutes = time_dropdown(question[:id], 0, 60, 15, minutes_label, raw_minutes_label, false)

    safe_join([hours, minutes])
  end
  # rubocop:enable Metrics/PerceivedComplexity

  # rubocop:disable Metrics/ParameterLists
  def time_dropdown(question_id, from_time, to_time, step, label, raw_label, am_pm)
    elem_id = idify(question_id, raw_label)
    options = generate_dropdown((from_time...to_time).step(BigDecimal(step.to_s)), elem_id, am_pm)
    options = safe_join([
                          options,
                          tag.label(label)
                        ])
    tag.div(options, class: "col m6 l1 no-padding #{elem_id}")
  end
  # rubocop:enable Metrics/ParameterLists

  def generate_dropdown(items, id, am_pm)
    body = []
    items.each do |option|
      option_value = number_to_string(option)
      option_string = option_value
      if am_pm
        option_string = if option == 12
                          '12 PM'
                        elsif option > 12
                          "#{number_to_string(option - 12)} PM"
                        else
                          "#{number_to_string(option)} AM"
                        end
      end
      body << tag.option(option_string, value: option_value)
    end
    body = safe_join(body)
    tag.select(body, name: answer_name(id), id: id, required: true, class: 'browser-default')
  end
end
