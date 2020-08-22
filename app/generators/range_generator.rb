# frozen_string_literal: true

class RangeGenerator < QuestionTypeGenerator
  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    slider_body = range_slider(question)
    slider_body = tag.div(slider_body,
                          class: "range-container notchanged#{question[:required].present? ? ' required' : ''}")
    safe_join([
                tag.p(title, class: 'flow-text'),
                slider_body,
                range_labels(question)
              ])
  end

  def range_slider_minmax(question)
    range_min = 0
    range_max = 100
    range_min = [range_min, question[:min]].max if question[:min].present? && question[:min].is_a?(Integer)
    range_max = [range_min + 1, question[:max]].max if question[:max].present? && question[:max].is_a?(Integer)
    { min: range_min, max: range_max }
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
    # TODO: Make this code prettier.
    unless question[:value].nil?
      range_body = tag(:input,
                       type: 'range',
                       id: idify(question[:id]),
                       name: answer_name(idify(question[:id])),
                       min: minmax[:min].to_s,
                       max: minmax[:max].to_s,
                       step: question[:step] || 1,
                       required: true,
                       value: question[:value])
    end
    tag.p(range_body,
          class: 'range-field')
  end

  def range_labels(question)
    labels_body = []
    label_count = [question[:labels].size, 1].max
    col_class = 12 / label_count
    col_width = 100.0 / label_count
    col_width = 100.0 / (label_count - 1) if label_count > 3
    question[:labels].each_with_index do |label, idx|
      new_col_width = col_width
      if label_count > 3
        new_col_width /= 2.0 if idx.zero? || idx + 1 == label_count
      end
      labels_body << label_div(label, col_class, new_col_width, idx, label_count)
    end
    labels_body = safe_join(labels_body)
    tag.div(labels_body, class: 'row')
  end

  def label_div(label, col_class, col_width, idx, label_count)
    alignment = 'center-align'
    alignment = 'left-align' if idx.zero?
    alignment = 'right-align' if idx + 1 == label_count
    tag.div(label,
            class: "col #{alignment} s#{col_class}",
            style: "width: #{col_width}%")
  end
end
