# frozen_string_literal: true

class LikertGenerator < QuestionTypeGenerator
  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    question = add_otherwise_label(question)
    safe_join([
                content_tag(:p, title, class: 'flow-text'),
                likert_options(question)
              ])
  end

  private

  def likert_options(question)
    body = []
    question[:options].each_with_index do |option, idx|
      body << likert_option_body(question, add_raw_to_option(option, question, idx), question[:response_id])
    end
    #safe_join(body)
    content_tag(:div, safe_join(body), class: 'likert-scale')
  end

  def likert_option_body(question, option, response_id)
    elem_id = idify(question[:id], option[:raw][:title])
    tag_options = question_options(question, option, elem_id)
    tag_options = add_shows_hides_questions(tag_options, option[:shows_questions], option[:hides_questions])

    option_body = tag(:input, tag_options)
    option_body = decorate_with_label(question, option_body, option)
    content_tag(:div, option_body, class: 'likert-item')
  end

  def question_options(question, option, elem_id)
    {
      name: answer_name(idify(question[:id])),
      type: 'radio',
      id: elem_id,
      value: option[:title],
      required: true,
      class: 'validate'
    }
  end

  def likert_body_wrap(question_id, option, wrapped_tag, answer_key, answer_value, response_id)
    title = content_tag(:span,
                        option[:title].html_safe)

    option_body = safe_join([
                              wrapped_tag,
                              content_tag(:label, title, class: 'flow-text', for: idify(question_id,
                                                                                        option[:raw][:title])),
                              generate_tooltip(option[:tooltip])
                            ])
    option_body = safe_join([
                              content_tag(:p, option_body),
                              stop_subscription_token(option, answer_key, answer_value, response_id)
                            ])
    option_body
  end
end
