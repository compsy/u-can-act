# frozen_string_literal: true

class CheckboxGenerator < Generator
  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    question = add_otherwise_label(question)
    checkbox_group = safe_join([
                                 content_tag(:p, title, class: 'flow-text'),
                                 checkbox_options(question),
                                 checkbox_otherwise(question)
                               ])
    content_tag(:div, checkbox_group, class: checkbox_group_klasses(question))
  end

  private

  def checkbox_group_klasses(question)
    klasses = 'checkbox-group'
    klasses += ' required' if question[:required].present?
    klasses
  end

  def checkbox_options(question)
    body = []
    question[:options].each_with_index do |option, idx|
      body << checkbox_option_body(question[:id], add_raw_to_option(option, question, idx), question[:response_id])
    end
    safe_join(body)
  end

  def checkbox_option_body(question_id, option, response_id)
    elem_id = idify(question_id, option[:raw][:title])
    tag_options = {
      type: 'checkbox',
      id: elem_id,
      name: answer_name(elem_id),
      value: true
    }
    tag_options = add_shows_hides_questions(tag_options, option[:shows_questions], option[:hides_questions])
    wrapped_tag = tag(:input, tag_options)
    option_body_wrap(question_id, option, wrapped_tag, elem_id, 'true', response_id)
  end

  def checkbox_otherwise(question)
    return '' if question.key?(:show_otherwise) && !question[:show_otherwise]
    option_body = safe_join([
                              checkbox_otherwise_option(question),
                              otherwise_textfield(question),
                              generate_tooltip(question[:otherwise_tooltip])
                            ])
    option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
    option_body
  end

  def checkbox_otherwise_option(question)
    safe_join([
                tag(:input,
                    type: 'checkbox',
                    id: idify(question[:id], question[:raw][:otherwise_label]),
                    name: answer_name(idify(question[:id], question[:raw][:otherwise_label])),
                    value: true,
                    class: 'otherwise-option'),
                otherwise_option_label(question)
              ])
  end
end
