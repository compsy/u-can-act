# frozen_string_literal: true

class NextQuestionnaireNoticeGenerator < QuestionTypeGenerator
  BASE_TEXT = "Klik hieronder op 'Opslaan' om de antwoorden in te leveren"
  WITH_NEXT_SUFFIX = ' en door te gaan naar de volgende vragenlijst'

  def generate(question)
    suffix = next_response?(question[:response_id]) ? WITH_NEXT_SUFFIX : ''
    tag.p("#{BASE_TEXT}#{suffix}.", class: 'flow-text')
  end

  private

  def next_response?(current_response_id)
    response = Response.find_by(id: current_response_id)
    return false if response.blank?

    person = response.protocol_subscription.person
    person.my_open_responses(person.mentor?).any? { |r| r.id != response.id }
  end
end
