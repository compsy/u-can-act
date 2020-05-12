# frozen_string_literal: true

class QuestionnaireGenerator
  include ActionView::Helpers

  def initialize
    @questionnaire_question_qenerator = QuestionnaireQuestionGenerator.new
  end

  # rubocop:disable Metrics/ParameterLists
  # rubocop:disable Metrics/AbcSize
  def generate_questionnaire(response_id:, content:, title:, submit_text:,
                             action:, unsubscribe_url:, locale:, params: {})
    params[:response_id] = response_id
    params['content[locale]'] = locale
    response = Response.find_by(id: response_id) # allow nil response id for preview
    raw_content = QuestionnaireTranslator.translate_content(content[:questions].deep_dup, 'i18n')
    # Translate a second time to get rid of any remaining translation hashes because the i18n translation is optional
    raw_content = QuestionnaireTranslator.translate_content(raw_content,
                                                            Rails.application.config.i18n.default_locale.to_s)
    content = QuestionnaireTranslator.translate_content(content, locale)
    title = substitute_variables(response, title).first
    body = safe_join([
                       questionnaire_header(title),
                       questionnaire_hidden_fields(params),
                       questionnaire_questions_html(content[:questions], response, raw_content, unsubscribe_url),
                       submit_button(submit_text)
                     ])
    body = content_tag(:form, body, action: action, class: 'col s12', 'accept-charset': 'UTF-8', method: 'post')
    body
  end
  # rubocop:enable Metrics/ParameterLists
  # rubocop:enable Metrics/AbcSize

  def generate_hash_questionnaire(response_id, content, title)
    response = Response.find_by(id: response_id) # allow nil response id for preview
    title = substitute_variables(response, title).first
    content = questionnaire_questions(content[:questions], response) { |quest| quest }
    { title: title, content: content }
  end

  private

  def substitute_variables(response, obj_to_substitute)
    return obj_to_substitute if obj_to_substitute.blank?

    QuestionnaireExpander.expand_content(obj_to_substitute, response)
  end

  def questionnaire_header(title)
    return ''.html_safe if title.blank?

    header_body = content_tag(:h4, title, class: 'header')
    header_body = content_tag(:div, header_body, class: 'col s12')
    header_body = content_tag(:div, header_body, class: 'row')
    header_body
  end

  def questionnaire_hidden_fields(params)
    hidden_body = []
    hidden_body << tag(:input, name: 'utf8', type: 'hidden', value: '&#x2713;'.html_safe)
    params.each do |key, value|
      hidden_body << tag(:input, name: key.to_s, type: 'hidden', value: value) if value.present?
    end
    safe_join(hidden_body)
  end

  def questionnaire_questions_html(content, response, raw_content, unsubscribe_url)
    body = questionnaire_questions(content, response) do |quest, idx|
      quest[:response_id] = response&.id
      quest[:raw] = raw_content[idx]
      quest[:unsubscribe_url] = unsubscribe_url
      @questionnaire_question_qenerator.generate(quest)
    end
    safe_join(body)
  end

  def questionnaire_questions(content, response)
    body = []
    content.each_with_index do |question, idx|
      new_question = question.deep_dup
      new_question = substitute_variables(response, new_question)
      new_question.each do |quest|
        (body << yield(quest, idx)) if GeneratorLogic::ShowHideQuestion.should_show?(quest, response&.id)
      end
    end
    body
  end

  def submit_button(submit_text)
    submit_body = content_tag(:button,
                              submit_text,
                              type: 'submit',
                              class: 'btn waves-effect waves-light',
                              data: { disable_with: 'Bezig...' })
    submit_body = content_tag(:div, submit_body, class: 'col s12')
    submit_body = content_tag(:div, submit_body, class: 'row section')
    submit_body
  end
end
