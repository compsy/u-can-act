# frozen_string_literal: true

class TimeGenerator < QuestionTypeGenerator
  def generate(question)
    body = time_body(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([content_tag(:p, title, class: 'flow-text'), body])
  end

  private

  def time_body(question)
    from = question[:hours_from] || 0
    to = question[:hours_to] || 6
    step = question[:hours_step] || 1

    hours = time_dropdown(question[:id], from, to, step, 'Uren')
    minutes = time_dropdown(question[:id], 0, 60, 15, 'Minuten')

    safe_join([hours, minutes])
  end

  def time_dropdown(question_id, from_time, to_time, step, label)
    elem_id = idify(question_id, label)
    options = generate_dropdown((from_time...to_time).step(step), elem_id)
    options = safe_join([
                          options,
                          content_tag(:label, label)
                        ])
    content_tag(:div, options, class: "col m6 l1 no-padding #{elem_id}")
  end

  def generate_dropdown(items, id)
    body = []
    items.each do |option|
      body << content_tag(:option, option, value: option)
    end
    body = safe_join(body)
    content_tag(:select, body, name: answer_name(id), id: id, required: true, class: 'browser-default')
  end
end
