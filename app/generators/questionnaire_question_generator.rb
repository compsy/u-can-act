# frozen_string_literal: true

class QuestionnaireQuestionGenerator < Generator
  def initialize
    @generators = {
      radio: RadioGenerator.new,
      time: TimeGenerator.new,
      checkbox: CheckboxGenerator.new,
      range: RangeGenerator.new,
      textarea: TextareaGenerator.new,
      textfield: TextfieldGenerator.new,
      raw: RawGenerator.new,
      unsubscribe: UnsubscribeGenerator.new,
      date: DateGenerator.new,
      expandable: ExpandableGenerator.new,
      section_start: SectionStartGenerator.new,
      section_end: SectionEndGenerator.new,
      klasses: KlassesGenerator.new
    }
  end

  def generate(question)
    question_body = find_generator(question[:type]).generate(question)
    question_body = content_tag(:div, question_body, class: 'col s12')
    question_body = content_tag(:div, question_body,
                                class: find_generator(:klasses).generate(question).to_s)
    wrap_question_in_sections(question_body, question)
  end

  def find_generator(type)
    generator = @generators[type]
    return generator if generator.present?
    raise "Unknown question type #{type}"
  end

  def wrap_question_in_sections(question_body, question)
    body = []
    body << find_generator(:section_start).generate(question)
    body << question_body
    body << find_generator(:section_end).generate(question)
    body.compact
  end
end
