# frozen_string_literal: true

require 'rails_helper'

describe NextPageFinder do
  let(:person) { FactoryBot.create(:person) }

  describe 'get_next_page' do
    it 'requires a current_user' do
      expect { described_class.get_next_page }.to raise_error(ArgumentError, 'missing keyword: current_user')
    end

    it 'returns the redirect url if there is one in the provided measurement' do
      url = '/test'
      measurement = FactoryBot.create(:measurement, redirect_url: url)
      response = FactoryBot.create(:response, measurement: measurement)
      result = described_class.get_next_page(current_user: person, previous_response: response)
      expect(result).to eq url
    end

    it 'returns the next uuid on the questionnaire show route whenever the next response is provided' do
      response = FactoryBot.create(:response)
      result = described_class.get_next_page(current_user: person, next_response: response)
      expect(result).not_to be_blank
      expect(result).to eq Rails.application.routes.url_helpers.questionnaire_path(uuid: response.uuid)
    end

    it 'returns the next available questionnaire show uuid route whenever the next response is not provided' do
      response = FactoryBot.create(:response)
      expect(person).to receive(:my_open_responses).and_return([response])

      result = described_class.get_next_page(current_user: person)
      expect(result).not_to be_blank
      expect(result).to eq Rails.application.routes.url_helpers.questionnaire_path(uuid: response.uuid)
    end

    it 'returns the first of a list of available responses when multiple are available' do
      responses = FactoryBot.create_list(:response, 10)
      expect(person).to receive(:my_open_responses).and_return(responses)

      result = described_class.get_next_page(current_user: person)
      expect(result).not_to be_blank
      expect(result).to eq Rails.application.routes.url_helpers.questionnaire_path(uuid: responses.first.uuid)
    end

    it 'redirects to the mentor page if the person is a mentor and no questionnaires are available' do
      mentor = FactoryBot.create(:mentor)
      result = described_class.get_next_page(current_user: mentor)
      expect(result).to eq Rails.application.routes.url_helpers.mentor_overview_index_path
    end

    it 'redirects to the klaar_path if no questionnaires are available, nor is the current person a mentor' do
      result = described_class.get_next_page(current_user: person)
      expect(result).to eq Rails.application.routes.url_helpers.klaar_path
    end

    it 'gives back the one time response if it is open' do
      response = FactoryBot.create_list(:response, 1)
      expect(person).to receive(:my_open_one_time_responses).and_return(response)

      result = described_class.get_next_page(current_user: person)
      expect(result).not_to be_blank
      expect(result).to eq Rails.application.routes.url_helpers.questionnaire_path(uuid: response.first.uuid)
    end

    it 'gives me the otr response only when no previous response was provided' do
      response = FactoryBot.create_list(:response, 1)
      allow(person).to receive(:my_open_one_time_responses).and_return(response)
      response2 = FactoryBot.create(:response)
      result = described_class.get_next_page(current_user: person, previous_response: response2)
      expect(result).to_not be_blank
      expect(result).to eq Rails.application.routes.url_helpers.klaar_path
    end

    it 'gives the scheduled questionnaire priority over any potential open OTR' do
      response_otrs = FactoryBot.create_list(:response, 1)
      response_normal = FactoryBot.create_list(:response, 1)
      allow(person).to receive(:my_open_one_time_responses).and_return(response_otrs)
      allow(person).to receive(:my_open_responses).and_return(response_normal)
      result = described_class.get_next_page(current_user: person)
      expect(result).to_not be_blank
      expect(result).to eq Rails.application.routes.url_helpers.questionnaire_path(uuid: response_normal.first.uuid)
    end
  end
end
