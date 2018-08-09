# frozen_string_literal: true

class RadioGenerator < Generator
  def generate(question)
    # TODO: Add radio button validation error message
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    question = add_otherwise_label(question)
    safe_join([
                content_tag(:p, title, class: 'flow-text'),
                radio_options(question),
                radio_otherwise(question)
              ])
  end

  def radio_options(question)
    body = []
    question[:options].each_with_index do |option, idx|
      body << radio_option_body(question[:id], add_raw_to_option(option, question, idx), question[:response_id])
    end
    safe_join(body)
  end

  def radio_option_body(question_id, option, response_id)
    elem_id = idify(question_id, option[:raw][:title])
    answername = answer_name(idify(question_id))
    tag_options = {
      name: answername,
      type: 'radio',
      id: elem_id,
      value: option[:title],
      required: true,
      class: 'validate'
    }
    tag_options = add_shows_hides_questions(tag_options, option[:shows_questions], option[:hides_questions])
    wrapped_tag = tag(:input, tag_options)
    option_body_wrap(question_id, option, wrapped_tag, idify(question_id), option[:title], response_id)
  end

  def radio_otherwise(question)
    return '' if question.key?(:show_otherwise) && !question[:show_otherwise]
    option_body = safe_join([
                              radio_otherwise_option(question),
                              otherwise_textfield(question),
                              generate_tooltip(question[:otherwise_tooltip])
                            ])
    option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
    # option_body_wrap(question_id, option_body, wrapped_tag, idify(question_id), option[:title], response_id)
    option_body
  end

  def radio_otherwise_option(question)
    safe_join([
                tag(:input,
                    name: answer_name(idify(question[:id])),
                    type: 'radio',
                    id: idify(question[:id], question[:raw][:otherwise_label]),
                    value: question[:otherwise_label],
                    required: true,
                    class: 'otherwise-option'),
                otherwise_option_label(question)
              ])
  end
end
