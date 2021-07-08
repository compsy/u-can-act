# frozen_string_literal: true

class GentleGenerator < QuestionTypeGenerator
  include React::Rails::ViewHelper

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([tag.p(title, class: 'flow-text'), gentle_field(question)])
  end

  private

  def gentle_field(question)
    body = gentle_tag(question)
    body = tag.div(body, class: 'col s12')
    tag.div(body, class: 'row')
  end

  def gentle_tag(question)
    react_component(
      'GentleWrapper',
      id: idify(question[:id]),
      network: question[:network],
      name: answer_name(question[:id]),
      required: question[:required].present?
    )
  end
end
