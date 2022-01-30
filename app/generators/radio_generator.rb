# frozen_string_literal: true

class RadioGenerator < QuestionTypeGenerator
  def generate(question)
    # TODO: Add radio button validation error message
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    question = add_otherwise_label(question)
    radio_group = safe_join([
                              tag.p(title, class: 'flow-text'),
                              answer_options(question),
                              radio_otherwise(question)
                            ])
    tag.div(radio_group, class: radio_group_klasses(question))
  end

  def radio_group_klasses(question)
    klasses = 'radio-group'
    klasses += ' required' unless question.key?(:required) && question[:required] == false
    klasses
  end

  private

  def answer_options(question)
    body = []
    question[:options].each_with_index do |option, idx|
      body << radio_option_body(question, add_raw_to_option(option, question, idx))
    end
    safe_join(body)
  end

  def radio_option_body(question, option)
    elem_id = idify(question[:id], option[:raw][:value].presence || option[:raw][:title])
    tag_options = question_options(question, option, elem_id)
    tag_options = add_shows_hides_questions(tag_options, option[:shows_questions], option[:hides_questions])

    option_body = tag.input(**tag_options)
    option_body = decorate_with_label(question, option_body, option)
    decorate_with_stop_subscription(question, option_body, option)
  end

  def decorate_with_stop_subscription(question, option_body, option)
    safe_join(
      [
        option_body,
        stop_subscription_token(option, idify(question[:id]), option[:title], question[:response_id])
      ]
    )
  end

  def question_options(question, option, elem_id)
    {
      name: answer_name(idify(question[:id])),
      type: 'radio',
      id: elem_id,
      value: option[:raw][:value].presence || option[:raw][:title],
      required: !(question.key?(:required) && question[:required] == false),
      class: 'validate'
    }
  end

  def radio_otherwise(question)
    return '' if question.key?(:show_otherwise) && !question[:show_otherwise]

    option_body = radio_otherwise_option(question)
    decorate_with_otherwise(question, option_body)
  end

  def radio_otherwise_option(question)
    tag.input(name: answer_name(idify(question[:id])),
              type: 'radio',
              id: idify(question[:id], question[:raw][:otherwise_label]),
              value: question[:raw][:otherwise_label],
              required: true,
              class: 'otherwise-option')
  end
end
