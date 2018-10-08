# frozen_string_literal: true

class KlassesGenerator < Generator
  def generate(question)
    klasses = 'row section'
    klasses += ' hidden' if question[:hidden].present?
    klasses += ' no-title' if question.key?(:title) && question[:title].blank?
    klasses += " #{idify(question[:id], 'toggle')}" if question.key?(:hidden) # hides_questions need hidden: false
    klasses
  end
end
