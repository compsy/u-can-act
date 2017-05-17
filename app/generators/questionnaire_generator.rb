# frozen_string_literal: true

class QuestionnaireGenerator
  extend ActionView::Helpers

  def self.generate_questionnaire(response)
    questionnaire = response.measurement.questionnaire
    body = ''.html_safe
    header_body = content_tag(:h4, questionnaire.name, class: 'header')
    header_body = content_tag(:div, header_body, class: 'row')
    body += header_body
    questionnaire.content.each do |question|
      question_body = case question[:type]
                        when :radio
                          generate_radio(question)
                        when :checkbox
                          generate_checkbox(question)
                        when :range
                          generate_range(question)
                        else
                          raise 'Unknown question type'
                      end
      body += content_tag(:div, question_body, class: 'row section no-pad-top')
    end
    submit_body = tag(:input,
                      type: 'submit',
                      name: 'commit',
                      value: 'Opslaan',
                      class: 'btn waves-effect waves-light')
    submit_body = content_tag(:div, submit_body, class: 'row section')
    body += submit_body
    # TODO: Add action, method, etc. to form
    body = content_tag(:form, body, class: 'col s12')
    body
  end

  def self.generate_radio(question)
    # TODO: Add radio button validation error message
    body = content_tag(:p, question[:title], class: 'flow-text')
    question[:options].each do |option|
      option_body = tag(:input,
                        name: idify(question[:id]),
                        type: 'radio',
                        id: idify(question[:id], option),
                        value: option,
                        required: true,
                        class: 'validate')
      option_body+= content_tag(:label, option, for: idify(question[:id], option), class: 'flow-text')
      option_body = content_tag(:p, option_body)
      body += option_body
    end
    option_text = 'Anders, namelijk:'
    option_field = tag(:input,
                       id: idify(question[:id], option_text, 'text'),
                       type: 'text',
                       disabled: true,
                       required: true,
                       class: 'validate otherwise')
    option_field+= content_tag(:label, 'Vul iets in', for: idify(question[:id], option_text, 'text'))
    option_field = content_tag(:div, option_field, class: 'input-field inline')
    option_body = tag(:input,
                      name: idify(question[:id]),
                      type: 'radio',
                      id: idify(question[:id], option_text),
                      value: option_text,
                      required: true,
                      class: 'otherwise-option')
    option_body+= content_tag(:label, option_text, for: idify(question[:id], option_text), class: 'flow-text')
    option_body+= option_field
    option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
    body += option_body
    body
  end

  def self.generate_checkbox(question)
    body = content_tag(:p, question[:title], class: 'flow-text')
    question[:options].each do |option|
      option_body = tag(:input,
                        type: 'checkbox',
                        id: idify(question[:id], option),
                        value: option)
      option_body+= content_tag(:label, option, for: idify(question[:id], option), class: 'flow-text')
      option_body = content_tag(:p, option_body)
      body += option_body
    end
    option_text = 'Anders, namelijk:'
    option_field = tag(:input,
                       id: idify(question[:id], option_text, 'text'),
                       type: 'text',
                       disabled: true,
                       required: true,
                       class: 'validate otherwise')
    option_field+= content_tag(:label, 'Vul iets in', for: idify(question[:id], option_text, 'text'))
    option_field = content_tag(:div, option_field, class: 'input-field inline')
    option_body = tag(:input,
                      type: 'checkbox',
                      id: idify(question[:id], option_text),
                      value: option_text,
                      class: 'otherwise-option')
    option_body+= content_tag(:label, option_text, for: idify(question[:id], option_text), class: 'flow-text')
    option_body+= option_field
    option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
    body += option_body
    body
  end

  def self.generate_range(question)
    body = content_tag(:p, question[:title], class: 'flow-text')
    range_body = tag(:input, type: 'range', id: idify(question[:id]), min: '0', max: '100', required: true)
    labels_body = ''.html_safe
    # Works with 2, 3, or 4 labels
    col_class = 12/[question[:labels].size, 1].max
    question[:labels].each_with_index do |label, idx|
      align_class = case idx
                      when 0
                        'left-align'
                      when (question[:labels].size - 1)
                        'right-align'
                      else
                        'center-align'
                    end
      labels_body += content_tag(:div, label, class: "col #{align_class} s#{col_class}")
    end
    labels_body = content_tag(:div, labels_body, class: 'row')
    range_body+= labels_body
    range_body = content_tag(:p, range_body, class: 'range-field')
    body += range_body
    body
  end

  def self.idify(*strs)
    strs.map {|x| x.to_s.parameterize.underscore}.join('_')
  end

end
