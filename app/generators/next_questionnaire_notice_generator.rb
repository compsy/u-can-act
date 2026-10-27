# frozen_string_literal: true

class NextQuestionnaireNoticeGenerator < QuestionTypeGenerator
  def generate(question)
    locale = question[:locale]
    key = next_response?(question[:response_id]) ? 'next_questionnaire_notice_with_next' : 'next_questionnaire_notice'
    text = I18n.t("questionnaires.#{key}", save: I18n.t('questionnaires.save', locale: locale), locale: locale)
    tag.p("#{text}.", class: 'flow-text')
  end

  private

  def next_response?(current_response_id)
    response = Response.find_by(id: current_response_id)
    return false if response.blank?

    person = response.protocol_subscription.person
    person.my_open_responses(person.mentor?).any? { |r| r.id != response.id }
  end
end
