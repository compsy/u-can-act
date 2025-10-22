# frozen_string_literal: true

class CheckboxGenerator < QuestionTypeGenerator
  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    question = add_otherwise_label(question)
    checkbox_group = safe_join([
                                 tag.p(title, class: 'flow-text'),
                                 answer_options(question),
                                 checkbox_otherwise(question)
                               ])
    div_options = { class: checkbox_group_klasses(question) }
    div_options['data-max-selections'] = question[:max_selections] if question[:max_selections].present?
    tag.div(checkbox_group, **div_options)
  end

  private

  def checkbox_group_klasses(question)
    klasses = 'checkbox-group'
    klasses += ' required' if question[:required].present?
    klasses
  end

  def answer_options(question)
    body = []
    question[:options].each_with_index do |option, idx|
      body << checkbox_option_body(question, add_raw_to_option(option, question, idx))
    end
    safe_join(body)
  end

  def question_options(question, elem_id)
    decorate_with_previous_value(
      question,
      elem_id,
      {
        type: 'checkbox',
        id: elem_id,
        name: answer_name(elem_id),
        value: true
      }
    ) { |previous_value| [:checked, previous_value] }
  end

  def checkbox_option_body(question, option)
    elem_id = idify(question[:id], option[:raw][:value].presence || option[:raw][:title])
    tag_options = question_options(question, elem_id)
    tag_options = add_shows_hides_questions(tag_options, option[:shows_questions], option[:hides_questions])
    option_body = tag.input(**tag_options)

    safe_join(
      [
        decorate_with_label(question, option_body, option),
        stop_subscription_token(option, elem_id, 'true', question[:response_id])
      ]
    )
  end

  def checkbox_otherwise(question)
    return '' if question.key?(:show_otherwise) && !question[:show_otherwise]

    option_body = checkbox_otherwise_option(question)
    decorate_with_otherwise(question, option_body)
  end

  def checkbox_otherwise_option(question)
    id = idify(question[:id], question[:raw][:otherwise_label])
    tag.input(**decorate_with_previous_value(
      question,
      id,
      {
        type: 'checkbox',
        id: id,
        name: answer_name(id),
        value: true,
        class: 'otherwise-option'
      }
    ) { |previous_value| [:checked, previous_value] })
  end
end
