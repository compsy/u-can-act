# frozen_string_literal: true

require 'rails_helper'

describe Api::ResponseSerializer do
  subject(:json) { described_class.new(response).as_json.with_indifferent_access }

  let(:response) { FactoryBot.create(:response) }

  it 'contains the correct value for the uuid' do
    expect(response.uuid).not_to be_blank
    expect(json['uuid']).to eq response.uuid
  end

  it 'renders its questionnaire using the QuestionnaireShortSerializer' do
    expect(Api::QuestionnaireShortSerializer)
      .to receive(:new)
      .and_call_original
      .twice
    described_class.new(response).as_json
  end
end
