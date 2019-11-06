# frozen_string_literal: true

class RangeGenerator < QuestionTypeGenerator
  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([
                content_tag(:p, title, class: 'flow-text'),
                range_slider(question),
                range_labels(question)
              ])
  end

  private

  def range_slider(question)
    minmax = range_slider_minmax(question)
    range_body = tag(:input,
                     type: 'range',
                     id: idify(question[:id]),
                     name: answer_name(idify(question[:id])),
                     min: minmax[:min].to_s,
                     max: minmax[:max].to_s,
                     step: question[:step] || 1,
                     required: true)
    range_body = content_tag(:p, range_body,
                             class: 'range-field',
                             style: styles(question))
    range_body
  end

  def styles(question)
    label_count = [question[:labels].size, 1].max
    col_width = 100.0 / label_count
    col_width -= 8 # HACK: to get around padding that is in rem and not percentages
    "width:#{100 - col_width}%;margin-left:#{col_width / 2.0}%;margin-right:#{col_width / 2.0}%"
  end

  def range_slider_minmax(question)
    range_min = 0
    range_max = 100
    range_min = [range_min, question[:min]].max if question[:min].present? && question[:min].is_a?(Integer)
    range_max = [range_min + 1, question[:max]].max if question[:max].present? && question[:max].is_a?(Integer)
    { min: range_min, max: range_max }
  end

  def range_labels(question)
    labels_body = []
    label_count = [question[:labels].size, 1].max
    col_class = 12 / label_count
    col_width = 100.0 / label_count
    question[:labels].each do |label|
      labels_body << label_div(label, col_class, col_width)
    end
    labels_body = safe_join(labels_body)
    labels_body = content_tag(:div, labels_body, class: 'row')
    labels_body
  end

  def label_div(label, col_class, col_width)
    content_tag(:div, label,
                class: "col center-align s#{col_class}",
                style: "width: #{col_width}%")
  end
end
