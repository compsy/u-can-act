# frozen_string_literal: true

class SectionStartGenerator < Generator
  def generate(question)
    return nil if question[:section_start].blank?

    body = tag.h5(question[:section_start].html_safe)
    body = tag.div(body, class: 'col s12')
    klasses = 'extra-spacing row'
    klasses += ' hidden' if question[:hidden].present?
    klasses += " #{idify(question[:id], 'toggle')}" if question.key?(:hidden) # hides_questions need hidden: false
    body = tag.div(body, class: klasses)
    body
  end
end
