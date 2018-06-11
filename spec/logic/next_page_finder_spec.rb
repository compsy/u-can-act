# frozen_string_literal: true

require 'rails_helper'

describe NextPageFinder do
  let(:person) { FactoryBot.create(:person) }
  describe 'get_next_page' do
    it 'should require a current_user' do
      expect { described_class.get_next_page }.to raise_error(ArgumentError, 'missing keyword: current_user')
    end

    it 'should return the redirect url if there is one in the provided measurement' do
      url = '/test'
      measurement = FactoryBot.create(:measurement, redirect_url: url)
      response = FactoryBot.create(:response, measurement: measurement)
      result = described_class.get_next_page(current_user: person, previous_response: response)
      expect(result).to eq url
    end

    it 'should return the next uuid on the questionnaire show route whenever the next response is provided' do
      response = FactoryBot.create(:response)
      result = described_class.get_next_page(current_user: person, next_response: response)
      expect(result).to_not be_blank
      expect(result).to eq Rails.application.routes.url_helpers.questionnaire_path(uuid: response.uuid)
    end

    it 'should return the next available questionnaire show uuid route whenever the next response is not provided' do
      response = FactoryBot.create(:response)
      expect(person).to receive(:my_open_responses).and_return([response])

      result = described_class.get_next_page(current_user: person)
      expect(result).to_not be_blank
      expect(result).to eq Rails.application.routes.url_helpers.questionnaire_path(uuid: response.uuid)
    end

    it 'should return the first of a list of available responses when multiple are available' do
      responses = FactoryBot.create_list(:response, 10)
      expect(person).to receive(:my_open_responses).and_return(responses)

      result = described_class.get_next_page(current_user: person)
      expect(result).to_not be_blank
      expect(result).to eq Rails.application.routes.url_helpers.questionnaire_path(uuid: responses.first.uuid)
    end

    it 'should redirect to the mentor page if the person is a mentor and no questionnaires are available' do
      mentor = FactoryBot.create(:mentor)
      result = described_class.get_next_page(current_user: mentor)
      expect(result).to eq mentor_overview_index_path
    end

    it 'should redirect to the klaar_path if no questionnaires are available, nor is the current person a mentor' do
      result = described_class.get_next_page(current_user: person)
      expect(result).to eq klaar_path
    end
  end
end
