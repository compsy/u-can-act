# frozen_string_literal: true

class NumberGenerator < QuestionTypeGenerator
  NUMBER_PLACEHOLDER = 'Vul een getal in'

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([tag.p(title, class: 'flow-text'), number_field(question)])
  end

  private

  def number_field(question)
    body = safe_join([
                       number_tag(question),
                       number_label(question)
                     ])
    body = if question[:links_to_expandable].present?
             tag.div(body,
                     data: { expandable: question[:links_to_expandable].to_s },
                     class: 'input-field col s12 m6 links_to_expandable')
           else
             tag.div(body, class: 'input-field col s12 m6')
           end
    tag.div(body, class: 'row')
  end

  # rubocop:disable Metrics/AbcSize
  def number_tag(question)
    tag_options = minimal_tag_options(question)
    if question[:maxlength].present?
      tag_options[:maxlength] = question[:maxlength]
      tag_options[:size] = question[:maxlength]
    end
    tag_options[:min] = question[:min] if question[:min].present?
    tag_options[:max] = question[:max] if question[:max].present?
    tag_options[:step] = question[:step] if question[:step].present?
    tag.input(**tag_options)
  end
  # rubocop:enable Metrics/AbcSize

  def minimal_tag_options(question)
    id = idify(question[:id])
    decorate_with_previous_value(
      question,
      id,
      { type: 'number',
        id: id,
        name: answer_name(question[:id]),
        required: question[:required].present?,
        class: 'validate',
      }
    )
  end

  def number_label(question)
    tag.label(placeholder(question, NUMBER_PLACEHOLDER),
              for: idify(question[:id]),
              class: 'flow-text')
  end
end
