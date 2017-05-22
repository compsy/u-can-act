# frozen_string_literal: true

class QuestionnaireGenerator
  extend ActionView::Helpers

  OTHERWISE_TEXT = 'Anders, namelijk:'
  OTHERWISE_PLACEHOLDER = 'Vul iets in'
  SUBMIT_BUTTON_TEXT = 'Opslaan'

  def self.generate_questionnaire(response, authenticity_token)
    questionnaire = response.measurement.questionnaire
    body = safe_join([
                       questionnaire_header(questionnaire),
                       questionnaire_hidden_fields(response, authenticity_token),
                       questionnaire_questions(questionnaire),
                       submit_button
                     ])
    # TODO: Add action, method, etc. to form
    body = content_tag(:form, body, action: '/', class: 'col s12', 'accept-charset': 'UTF-8', method: 'post')
    body
  end

  def self.questionnaire_header(questionnaire)
    header_body = content_tag(:h4, questionnaire.name, class: 'header')
    header_body = content_tag(:div, header_body, class: 'col s12')
    header_body = content_tag(:div, header_body, class: 'row')
    header_body
  end

  def self.questionnaire_hidden_fields(response, authenticity_token)
    hidden_body = []
    hidden_body << tag(:input, name: 'utf8', type: 'hidden', value: '&#x2713;'.html_safe)
    hidden_body << tag(:input, name: 'authenticity_token', type: 'hidden', value: authenticity_token)
    hidden_body << tag(:input, name: 'response_id', type: 'hidden', value: response.id)
    safe_join(hidden_body)
  end

  def self.questionnaire_questions(questionnaire)
    body = []
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
      question_body = content_tag(:div, question_body, class: 'col s12')
      body = questionnaire_questions_add_question_section(body, question_body, question)
    end
    safe_join(body)
  end

  def self.questionnaire_questions_add_question_section(body, question_body, question)
    body << section_start(question[:section_start]) unless question[:section_start].blank?
    body << content_tag(:div, question_body, class: 'row section')
    body << section_end(question[:section_end]) unless question[:section_end].blank?
    body
  end

  def self.section_start(section_title)
    "<div class=\"extra-spacing row\"><div class=\"col s12\"><h5>#{section_title}</h5></div></div>".html_safe
  end

  def self.section_end(_unused_arg)
    '<div class="row"><div class="col s12"><div class="divider"></div></div></div>'.html_safe
  end

  def self.submit_button
    submit_body = content_tag(:button,
                              SUBMIT_BUTTON_TEXT,
                              type: 'submit',
                              class: 'btn waves-effect waves-light')
    submit_body = content_tag(:div, submit_body, class: 'col s12')
    submit_body = content_tag(:div, submit_body, class: 'row section')
    submit_body
  end

  def self.answer_name(name)
    "content[#{name}]"
  end

  def self.generate_radio(question)
    # TODO: Add radio button validation error message
    safe_join([
                content_tag(:p, question[:title].html_safe, class: 'flow-text'),
                radio_options(question),
                radio_otherwise(question)
              ])
  end

  def self.radio_options(question)
    body = []
    question[:options].each do |option|
      option_body = safe_join([
                                tag(:input,
                                    name: answer_name(idify(question[:id])),
                                    type: 'radio',
                                    id: idify(question[:id], option),
                                    value: option,
                                    required: true,
                                    class: 'validate'),
                                content_tag(:label,
                                            option,
                                            for: idify(question[:id], option),
                                            class: 'flow-text')
                              ])
      option_body = content_tag(:p, option_body)
      body << option_body
    end
    safe_join(body)
  end

  def self.radio_otherwise(question)
    option_body = safe_join([
                              radio_otherwise_option(question),
                              otherwise_textfield(question)
                            ])
    option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
    option_body
  end

  def self.radio_otherwise_option(question)
    safe_join([
                tag(:input,
                    name: idify(question[:id]),
                    type: 'radio',
                    id: idify(question[:id], OTHERWISE_TEXT),
                    value: OTHERWISE_TEXT,
                    required: true,
                    class: 'otherwise-option'),
                content_tag(:label,
                            OTHERWISE_TEXT,
                            for: idify(question[:id], OTHERWISE_TEXT),
                            class: 'flow-text')
              ])
  end

  def self.otherwise_textfield(question)
    # Used for both radios and checkboxes
    option_field = safe_join([
                               tag(:input,
                                   id: idify(question[:id], OTHERWISE_TEXT, 'text'),
                                   name: answer_name(idify(question[:id], OTHERWISE_TEXT, 'text')),
                                   type: 'text',
                                   disabled: true,
                                   required: true,
                                   class: 'validate otherwise'),
                               content_tag(:label,
                                           OTHERWISE_PLACEHOLDER,
                                           for: idify(question[:id], OTHERWISE_TEXT, 'text'))
                             ])
    option_field = content_tag(:div, option_field, class: 'input-field inline')
    option_field
  end

  def self.generate_checkbox(question)
    safe_join([
                content_tag(:p, question[:title].html_safe, class: 'flow-text'),
                checkbox_options(question),
                checkbox_otherwise(question)
              ])
  end

  def self.checkbox_options(question)
    body = []
    question[:options].each do |option|
      option_body = safe_join([
                                tag(:input,
                                    type: 'checkbox',
                                    id: idify(question[:id], option),
                                    name: answer_name(idify(question[:id], option)),
                                    value: true),
                                content_tag(:label,
                                            option,
                                            for: idify(question[:id], option),
                                            class: 'flow-text')
                              ])
      option_body = content_tag(:p, option_body)
      body << option_body
    end
    safe_join(body)
  end

  def self.checkbox_otherwise(question)
    option_body = safe_join([
                              checkbox_otherwise_option(question),
                              otherwise_textfield(question)
                            ])
    option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
    option_body
  end

  def self.checkbox_otherwise_option(question)
    safe_join([
                tag(:input,
                    type: 'checkbox',
                    id: idify(question[:id], OTHERWISE_TEXT),
                    name: answer_name(idify(question[:id], OTHERWISE_TEXT)),
                    value: true,
                    class: 'otherwise-option'),
                content_tag(:label,
                            OTHERWISE_TEXT,
                            for: idify(question[:id], OTHERWISE_TEXT),
                            class: 'flow-text')
              ])
  end

  def self.generate_range(question)
    safe_join([
                content_tag(:p, question[:title].html_safe, class: 'flow-text'),
                range_slider(question),
                range_labels(question)
              ])
  end

  def self.range_slider(question)
    minmax = range_slider_minmax(question)
    range_body = tag(:input,
                     type: 'range',
                     id: idify(question[:id]),
                     name: answer_name(idify(question[:id])),
                     min: minmax[:min].to_s,
                     max: minmax[:max].to_s,
                     required: true)
    range_body = content_tag(:p, range_body, class: 'range-field')
    range_body
  end

  def self.range_slider_minmax(question)
    range_min = 0
    range_max = 100
    range_min = [range_min, question[:min]].max if question[:min].present? && question[:min].is_a?(Integer)
    range_max = [range_min + 1, question[:max]].max if question[:max].present? && question[:max].is_a?(Integer)
    { min: range_min, max: range_max }
  end

  def self.range_labels(question)
    # Works best with 2, 3, or 4 labels
    labels_body = []
    col_class = 12 / [question[:labels].size, 1].max
    question[:labels].each_with_index do |label, idx|
      align_class = case idx
                    when 0
                      'left-align'
                    when (question[:labels].size - 1)
                      'right-align'
                    else
                      'center-align'
                    end
      labels_body << content_tag(:div, label, class: "col #{align_class} s#{col_class}")
    end
    labels_body = safe_join(labels_body)
    labels_body = content_tag(:div, labels_body, class: 'row')
    labels_body
  end

  def self.idify(*strs)
    strs.map { |x| x.to_s.parameterize.underscore }.join('_')
  end
end
