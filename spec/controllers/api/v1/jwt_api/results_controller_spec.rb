# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::JwtApi::ResultsController, type: :controller do
  let(:questionnaire) { FactoryBot.create(:questionnaire) }
  let(:other_response) { FactoryBot.create(:response) }

  describe 'distribution' do
    let!(:the_auth_user) { FactoryBot.create(:auth_user) }
    let(:protocol) { FactoryBot.create(:protocol) }
    let(:team) { FactoryBot.create(:team, :with_roles) }
    let!(:the_payload) do
      { ENV.fetch('SITE_LOCATION', nil) => {
        'access_level' => ['user'],
        'team' => team.name,
        'protocol' => protocol.name
      } }
    end

    before do
      allow(Rails.application.config.settings.feature_toggles).to receive(:allow_distribution_export).and_return(true)
      allow(Rails.application.config.settings).to(receive(:distribution_export_min_responses).and_return(0))
      allow(RedisService).to receive(:get).and_return({ 'total' => 1 }.to_json)
    end

    describe 'general' do
      let!(:questionnaire) { FactoryBot.create(:questionnaire) }
      let!(:the_params) { { questionnaire_key: questionnaire.key } }
      it_behaves_like 'a jwt authenticated route', 'get', :distribution
    end

    describe 'specific' do
      before do
        the_payload[:sub] = the_auth_user.auth0_id_string
        jwt_auth the_payload
      end

      it 'sets the correct env vars if the questionnaire is available' do
        get :distribution, params: { questionnaire_key: questionnaire.key }
        expect(response.status).to eq 200
        expect(controller.instance_variable_get(:@questionnaire)).to eq(questionnaire)
      end

      it 'returns the correct value' do
        get :distribution, params: { questionnaire_key: questionnaire.key }
        expect(response.body).to eq '{"total":1}'
      end
    end
  end
end
