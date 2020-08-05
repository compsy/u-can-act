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
    # It is important that the raw content is always in the same language, because it defines the keys in the response
    # hash, e.g. v1_brood for a checkbox question with an answer named pizza. We wouldn't want to see a v1_bread column
    # appear in the CSV export when that represents the same answer, just in a different language. The v1 keys for
    # checkboxes are determined by their raw labels, hence we make sure that the raw labels are language independent
    # (note: this is not the label that is shown to the user, it is merely used for the name/id of the elements on the
    # page).
    # We translate the raw content twice because the i18n language is optional, and if a translated string only has an
    # 'nl' and 'en' component, it will be left untranslated in the string, which will give errors down the line when
    # it expects a string and finds a hash. This is why after using the i18n translated strings wherever we can, we do a
    # second pass to translate any remaining untranslated strings to the default language.
    raw_content = QuestionnaireTranslator.translate_content(content[:questions].deep_dup, 'i18n')
    # Translate a second time to get rid of any remaining translation hashes because the i18n translation is optional
    raw_content = QuestionnaireTranslator.translate_content(raw_content,
                                                            Rails.application.config.i18n.default_locale.to_s)
    # The content needs its own parsing step, since there we don't want any i18n labels.
    content = QuestionnaireTranslator.translate_content(content, locale)
    title = substitute_variables(response, title).first
    body = safe_join([
                       questionnaire_header(title),
                       questionnaire_hidden_fields(params),
                       questionnaire_questions_html(content[:questions], response, raw_content, unsubscribe_url),
                       submit_button(submit_text)
                     ])
    tag.form(body, action: action, class: 'col s12', 'accept-charset': 'UTF-8', method: 'post')
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

    header_body = tag.h4(title, class: 'header')
    header_body = tag.div(header_body, class: 'col s12')
    tag.div(header_body, class: 'row')
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
    submit_body = tag.button(submit_text,
                             type: 'submit',
                             class: 'btn waves-effect waves-light',
                             data: { disable_with: 'Bezig...' })
    submit_body = tag.div(submit_body, class: 'col s12')
    tag.div(submit_body, class: 'row section')
  end
end
