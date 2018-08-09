# frozen_string_literal: true

class TextfieldGenerator < Generator
  def generate
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([content_tag(:p, title, class: 'flow-text'), textfield_field(question)])
  end

  def textfield_field(question)
    body = safe_join([
                       textfield_tag(question),
                       textfield_label(question)
                     ])
    body = content_tag(:div, body, class: 'input-field col s12')
    body = content_tag(:div, body, class: 'row')
    body
  end

  def textfield_tag(question)
    tag(:input,
        type: 'text',
        id: idify(question[:id]),
        name: answer_name(question[:id]),
        required: question[:required].present?,
        class: 'validate')
  end

  def textfield_label(question)
    content_tag(:label,
                placeholder(question, TEXTFIELD_PLACEHOLDER),
                for: idify(question[:id]),
                class: 'flow-text')
  end
end
