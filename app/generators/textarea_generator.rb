# frozen_string_literal: true

class TextareaGenerator < QuestionTypeGenerator
  TEXTAREA_PLACEHOLDER = 'Vul iets in'

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([tag.p(title, class: 'flow-text'), textarea_field(question)])
  end

  private

  def textarea_field(question)
    body = safe_join([
                       textarea_tag(question),
                       textarea_label(question)
                     ])
    body = tag.div(body, class: 'input-field col s12')
    tag.div(body, class: 'row')
  end

  def textarea_tag(question)
    tag.textarea(nil,
                 id: idify(question[:id]),
                 name: answer_name(question[:id]),
                 required: question[:required].present?,
                 class: 'materialize-textarea validate')
  end

  def textarea_label(question)
    tag.label(placeholder(question, TEXTAREA_PLACEHOLDER),
              for: idify(question[:id]),
              class: 'flow-text')
  end
end
