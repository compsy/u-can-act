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

  context 'when response_id is nil (preview mode)' do
    it 'renders the short notice without raising' do
      result = subject.generate(response_id: nil)
      expect(result).to include(base_phrase)
      expect(result).not_to include(next_phrase)
    end
  end
end
