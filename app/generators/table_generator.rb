# frozen_string_literal: true

class TableGenerator < QuestionTypeGenerator
  def generate(question)
    table_body = build_table(question)
    question_body = safe_join([
                                generate_title(question),
                                tag.div(table_body, class: 'table-wrapper'),
                                generate_tooltip(question[:tooltip])
                              ])

    tag.div(question_body, class: 'table-question')
  end

  private

  def build_table(question)
    table_content = safe_join([
                                build_table_header(question),
                                build_table_body(question)
                              ])

    tag.table(table_content, class: 'highlight questionnaire-table')
  end

  def build_table_header(question)
    header_cells = [tag.th('Activity', class: 'table-row-label table-header-cell')] # Header for row labels

    question[:options].each do |option|
      header_cells << tag.th(option, class: 'table-column-header table-header-cell')
    end

    header_row = tag.tr(safe_join(header_cells), class: 'table-header-row')
    tag.thead(header_row)
  end

  def build_table_body(question)
    rows = []

    question[:rows].each_with_index do |row, _row_index|
      row_cells = [tag.td(row[:title], class: 'table-row-label')]

      question[:options].each_with_index do |option, option_index|
        radio_input = build_radio_input(question, row, option, option_index)
        cell_content = tag.div(radio_input, class: 'table-radio-cell')
        row_cells << tag.td(cell_content, class: 'table-option-cell')
      end

      rows << tag.tr(safe_join(row_cells), class: 'table-row')
    end

    tag.tbody(safe_join(rows))
  end

  def build_radio_input(question, row, _option, option_index)
    row_id = row[:id]
    input_options = build_input_options(question, row_id, option_index)
    input_options = apply_previous_value(question, row_id, input_options, option_index)
    input_options = apply_shows_hides(input_options, row)

    radio_input = tag.input(**input_options)
    label = build_radio_label(question, row_id, option_index)

    safe_join([radio_input, label])
  end

  def build_input_options(question, row_id, option_index)
    input_id = idify(question[:id], row_id, option_index)
    input_name = answer_name(row_id)

    options = {
      type: 'radio',
      id: input_id,
      name: input_name,
      value: option_index,
      class: 'table-radio-input'
    }

    options[:required] = true if question[:required]
    options
  end

  def apply_previous_value(question, row_id, input_options, option_index)
    decorate_with_previous_value(question, row_id, input_options) do |previous_value|
      [:checked, previous_value.to_s == option_index.to_s]
    end
  end

  def apply_shows_hides(input_options, row)
    add_shows_hides_questions(
      input_options,
      row[:shows_questions],
      row[:hides_questions]
    )
  end

  def build_radio_label(question, row_id, option_index)
    input_id = idify(question[:id], row_id, option_index)
    tag.label('', for: input_id, class: 'table-radio-label')
  end

  def generate_title(question)
    return nil if question[:title].blank?

    title_content = question[:title].html_safe
    tag.div(title_content, class: 'flow-text')
  end
end
