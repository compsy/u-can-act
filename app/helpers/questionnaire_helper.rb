# frozen_string_literal: true

module QuestionnaireHelper
  def generate_questionnaire(response)
    questionnaire = response.measurement.questionnaire
    body = ''.html_safe
    body += content_tag(:h3, questionnaire.name, class: 'header')
    email_field = tag(:input, id: 'email', type: 'email', class: 'validate')
    email_field += content_tag(:label, 'Email', for: 'email')
    email_field = content_tag(:div, email_field, class: 'input-field col s12')
    email_field = content_tag(:div, email_field, class: 'row')
    body += email_field
    body = content_tag(:form, body, class: 'col s12')
    body.html_safe
  end
end
