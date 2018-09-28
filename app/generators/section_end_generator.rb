# frozen_string_literal: true

class SectionEndGenerator < QuestionTypeGenerator
  def generate(question)
    return nil if question[:section_end].blank?

    body = content_tag(:div, nil, class: 'divider')
    body = content_tag(:div, body, class: 'col s12')
    klasses = 'row'
    klasses += ' hidden' if question[:hidden].present?
    klasses += " #{idify(question[:id], 'toggle')}" if question.key?(:hidden) # hides_questions need hidden: false
    body = content_tag(:div, body, class: klasses)
    body
  end
end
