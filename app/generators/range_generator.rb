# frozen_string_literal: true

class RangeGenerator < QuestionTypeGenerator
  include ConversionHelper

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    slider_body = safe_join([range_value_label(question), range_slider(question)])
    slider_body = tag.div(slider_body,
                          class: "range-container notchanged#{question[:required].present? ? ' required' : ''}" \
                                 "#{question[:no_initial_thumb].present? ? ' no-initial-thumb' : ''}")
    body_and_labels = join_body_and_labels(slider_body, range_labels(question), question)
    safe_join([
                tag.p(title, class: 'flow-text'),
                body_and_labels
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

  def join_body_and_labels(slider_body, labels, question)
    if question[:vertical].present?
      slider_body = tag.div(slider_body,
                            class: "col s3#{question[:gradient].present? ? ' gradient-bg' : ''}",
                            style: 'width: 55px; margin-left: 10px')
      labels = tag.div(labels, class: 'col s9')
      return tag.div(safe_join([slider_body, labels]), class: 'row')
    end
    safe_join([slider_body, labels])
  end

  def range_value_label(question)
    return nil if question[:vertical].present?

    tag.div('', class: 'range-value-label')
  end

  # rubocop:disable Metrics/AbcSize
  def range_slider(question)
    minmax = range_slider_minmax(question)
    step = question[:step] || 1
    range_options = range_question_options(minmax: minmax, step: step, question: question)
    range_options[:value] = question[:value] if question[:value].present?
    if question[:vertical].present?
      range_options[:class] = 'vranger'
      range_body = tag(:input, range_options)
      return tag.p(range_body, class: 'range-field')
    end
    unless question[:ticks].present?
      range_body = tag(:input, range_options)
      return tag.p(range_body, class: 'range-field')
    end
    range_slider_with_ticks(minmax: minmax, step: step, question: question, range_options: range_options)
  end
  # rubocop:enable Metrics/AbcSize

  def range_question_options(minmax:, step:, question:)
    {
      type: 'range',
      id: idify(question[:id]),
      name: answer_name(idify(question[:id])),
      min: minmax[:min].to_s,
      max: minmax[:max].to_s,
      step: step,
      required: question[:required].present?
    }
  end

  # Disabling this rubocop because tag.datalist is not a defined method.
  # rubocop:disable Rails/ContentTag
  def range_slider_with_ticks(minmax:, step:, question:, range_options:)
    range_options[:list] = idify(question[:id], 'datalist')
    range_body = tag(:input, range_options)
    datalist = range_datalist(min: minmax[:min], max: minmax[:max], step: step)
    range_datalist = content_tag(:datalist, datalist, id: idify(question[:id], 'datalist'))
    body = safe_join([range_body, range_datalist])
    tag.p(body, class: 'range-field with-ticks')
  end
  # rubocop:enable Rails/ContentTag

  def range_datalist(min:, max:, step:)
    body = []
    (min..max).step(step).each do |option|
      body << tag.option(number_to_string(option))
    end
    safe_join(body)
  end

  # rubocop:disable Metrics/AbcSize
  def range_labels(question)
    labels_body = []
    label_count = [question[:labels].size, 1].max
    col_class = 12 / label_count
    col_width = col_width_from_label_count(label_count)
    minmax = range_slider_minmax(question)
    step = (1.0 + minmax[:max] - minmax[:min]) / label_count
    cur = minmax[:min]
    return vertical_range_labels(minmax, step, col_width, question) if question[:vertical].present?

    question[:labels].each_with_index do |label, idx|
      new_col_width = col_width
      new_col_width /= 2.0 if label_count > 3 && (idx.zero? || idx + 1 == label_count)
      labels_body << label_div(label, col_class, new_col_width, idx, label_count, cur)
      cur += step
    end
    labels_body = safe_join(labels_body)
    tag.div(labels_body, class: 'row label-row')
  end
  # rubocop:enable Metrics/AbcSize

  def col_width_from_label_count(label_count)
    return 100.0 / (label_count - 1) if label_count > 3

    100.0 / label_count
  end

  def label_div(label, col_class, col_width, idx, label_count, value)
    alignment = 'center-align'
    alignment = 'left-align' if idx.zero?
    alignment = 'right-align' if idx + 1 == label_count
    tag.div(label,
            class: "col #{alignment} s#{col_class}",
            style: "width: #{col_width}%",
            data: { value: value })
  end

  def vertical_range_labels(minmax, step, col_width, question)
    labels_body = []
    (minmax[:min]..minmax[:max]).step(step).each_with_index do |value, idx|
      label = ''
      label += "- #{number_to_string(value)} " if question[:ticks].present?
      label += question[:labels][idx].to_s if question[:labels].present?
      labels_body << tag.div(label,
                             class: 'vertical-range-label',
                             style: "height: #{col_width}%",
                             data: { value: value })
    end
    tag.div(safe_join(labels_body), class: 'range-labels-vertical')
  end
end
