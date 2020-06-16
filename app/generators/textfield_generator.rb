# frozen_string_literal: true

class TextfieldGenerator < QuestionTypeGenerator
  TEXTFIELD_PLACEHOLDER = 'Vul iets in'

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([tag.p(title, class: 'flow-text'), textfield_field(question)])
  end

  private

  def textfield_field(question)
    body = safe_join([
                       textfield_tag(question),
                       textfield_label(question),
                       textfield_helper(question)
                     ])
    body = tag.div(body, class: 'input-field col s12 m6')
    body = tag.div(body, class: 'row')
    body
  end

  def textfield_tag(question)
    tag_options = minimal_tag_options(question)
    tag_options[:title] = question[:hint] if question[:hint].present?
    tag_options[:value] = question[:default_value] if question[:default_value].present?
    tag_options[:pattern] = question[:pattern] if question[:pattern].present?
    tag(:input, tag_options)
  end

  def minimal_tag_options(question)
    { type: 'text',
      id: idify(question[:id]),
      name: answer_name(question[:id]),
      required: question[:required].present?,
      class: 'validate' }
  end

  def textfield_label(question)
    tag.label(placeholder(question, TEXTFIELD_PLACEHOLDER),
              for: idify(question[:id]),
              class: 'flow-text')
  end

  def textfield_helper(question)
    return nil if question[:hint].blank?

    tag.span('', # Don't show a hint by default and don't show one when value is correct.
             data: { error: question[:hint], success: '' },
             class: 'helper-text')
  end
end
