# frozen_string_literal: true

require 'rails_helper'

describe NextQuestionnaireNoticeGenerator do
  subject { described_class.new }

  let(:base_phrase) { 'om de antwoorden in te leveren' }
  let(:next_phrase) { 'door te gaan naar de volgende vragenlijst' }

  context 'when there is another open response for the user' do
    let(:response) { FactoryBot.create(:response) }
    let(:other_response) { FactoryBot.create(:response) }

    before do
      allow(Response).to receive(:find_by).with(id: response.id).and_return(response)
      allow(response.protocol_subscription.person).to receive(:my_open_responses)
        .and_return([response, other_response])
    end

    it 'renders the notice with the "next questionnaire" suffix' do
      result = subject.generate(response_id: response.id)
      expect(result).to include(base_phrase)
      expect(result).to include(next_phrase)
    end
  end

  context 'when the current response is the only open one' do
    let(:response) { FactoryBot.create(:response) }

    before do
      allow(Response).to receive(:find_by).with(id: response.id).and_return(response)
      allow(response.protocol_subscription.person).to receive(:my_open_responses)
        .and_return([response])
    end

    it 'renders the short notice without mentioning the next questionnaire' do
      result = subject.generate(response_id: response.id)
      expect(result).to include(base_phrase)
      expect(result).not_to include(next_phrase)
    end
  end

  context 'with a locale' do
    it 'renders the notice in nl with the nl save button text' do
      expect(CGI.unescapeHTML(subject.generate(response_id: nil, locale: 'nl')))
        .to include("Klik hieronder op 'Opslaan' om de antwoorden in te leveren.")
    end

    it 'renders the notice in en with the en save button text' do
      expect(CGI.unescapeHTML(subject.generate(response_id: nil, locale: 'en')))
        .to include("Click 'Save' below to submit your answers.")
    end

    it 'renders the notice in fi with the fi save button text' do
      expect(CGI.unescapeHTML(subject.generate(response_id: nil, locale: 'fi'))).to include("'Tallenna'-painiketta.")
    end

    it 'falls back to en for other locales' do
      expect(CGI.unescapeHTML(subject.generate(response_id: nil, locale: 'de'))).to include("Click 'Save' below")
    end
  end

  context 'when response_id is nil (preview mode)' do
    it 'renders the short notice without raising' do
      result = subject.generate(response_id: nil)
      expect(result).to include(base_phrase)
      expect(result).not_to include(next_phrase)
    end
  end
end
