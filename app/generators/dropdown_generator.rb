# frozen_string_literal: true

class DropdownGenerator < QuestionTypeGenerator
  DROPDOWN_PLACEHOLDER = 'Selecteer uw antwoord...'

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([
                content_tag(:p, title, class: 'flow-text'),
                answer_options(question)
              ])
  end

  private

  def answer_options(question)
    label = question[:label]
    elem_id = idify(question[:id], label)
    options = generate_dropdown(question, elem_id)
    options = safe_join([
                          options,
                          content_tag(:label, label)
                        ])
    content_tag(:div, options, class: "input-field col s6 #{elem_id}")
  end

  def generate_dropdown(question, id)
    body = []
    placeholder = question[:placeholder] ? question[:placeholder] : DROPDOWN_PLACEHOLDER
    body << content_tag(:option, placeholder, disabled: nil, selected: nil, value: '')
    question[:options].each_with_index do |option, idx|
      body << content_tag(:option, option, value: question[:raw][:options][idx])
    end
    body = safe_join(body)
    content_tag(:select, body, name: answer_name(id), id: id, required: true)
  end
end
