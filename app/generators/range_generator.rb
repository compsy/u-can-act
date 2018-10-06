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
    range_body = content_tag(:p, range_body, class: 'range-field')
    range_body
  end

  def range_slider_minmax(question)
    range_min = 0
    range_max = 100
    range_min = [range_min, question[:min]].max if question[:min].present? && question[:min].is_a?(Integer)
    range_max = [range_min + 1, question[:max]].max if question[:max].present? && question[:max].is_a?(Integer)
    { min: range_min, max: range_max }
  end

  def range_labels(question)
    # Works best with 2, 3, or 4 labels
    labels_body = []
    col_class = 12 / [question[:labels].size, 1].max
    question[:labels].each_with_index do |label, idx|
      align_class = case idx
                    when 0
                      'left-align'
                    when (question[:labels].size - 1)
                      'right-align'
                    else
                      'center-align'
                    end
      labels_body << content_tag(:div, label, class: "col #{align_class} s#{col_class}")
    end
    labels_body = safe_join(labels_body)
    labels_body = content_tag(:div, labels_body, class: 'row')
    labels_body
  end
end
