# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::BasicAuthApi::QuestionnairesController, type: :controller do
  let!(:questionnaire) { FactoryBot.build(:questionnaire) }
  let!(:params) { { questionnaire: questionnaire.attributes } }

  describe 'general' do
    it_behaves_like 'a basic authenticated route', 'post', :create
  end

  describe '#CREATE' do
    before do
      basic_auth 'admin', 'admin'
    end

    it 'should head 201 if the questionnaire was created' do
      post :create, params: params
      expect(response.status).to eq 201
    end

    it 'should render a 400 if the provided questionnaire is incorrect' do
      post :create, params: { questionnaire: { test: 'nothing' } }
      expect(response.status).to eq 400
      expected = {
        result: {
          name: ['moet opgegeven zijn'],
          content: ['moet opgegeven zijn'],
          key: ['moet opgegeven zijn', 'is ongeldig']
        }
      }.to_json
      expect(response.body).to eq expected
    end
  end
end
