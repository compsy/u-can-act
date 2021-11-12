# frozen_string_literal: true

class DropdownGenerator < QuestionTypeGenerator
  DROPDOWN_PLACEHOLDER = 'Selecteer uw antwoord...'

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([
                tag.p(title, class: 'flow-text'),
                answer_options(question)
              ])
  end

  private

  def answer_options(question)
    label = question[:label]
    elem_id = idify(question[:id])
    options = generate_dropdown(question, elem_id)
    options = safe_join([
                          tag.label(label),
                          options
                        ])
    tag.div(options, class: "col s12 m6 no-padding #{elem_id}")
  end

  def generate_dropdown(question, id)
    body = []
    placeholder = question[:placeholder] || DROPDOWN_PLACEHOLDER
    body << tag.option(placeholder, disabled: true, selected: true, value: '')
    question[:options].each_with_index do |option, idx|
      body << dropdown_option_body(add_raw_to_option(option, question, idx))
    end
    body = safe_join(body)
    tag.select(body, name: answer_name(id), id: id, required: true, class: 'browser-default')
  end

  def dropdown_option_body(option)
    option_options = {
      value: option[:raw][:value].presence || option[:raw][:title]
    }
    option_options = add_shows_hides_questions(option_options, option[:shows_questions], option[:hides_questions])
    tag.option(option[:title].html_safe, **option_options)
  end
end
