# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Admin::OrganizationController, type: :controller do
  it_behaves_like 'a jwt authenticated route', :show, group: Person::STUDENT
  it_behaves_like 'a jwt authenticated route', :show, group: Person::MENTOR
  describe '#show' do
    let(:week_number) { '1' }
    let(:year) { '2018' }
    let(:percentage_threshold) { '70' }
    let(:group) { Person::STUDENT }
    let!(:organizations) { FactoryBot.create(:organization, :with_teams) }
    let(:overview) { Organization.overview bust_cache: true }
    let(:admin) { FactoryBot.create(:admin) }

    before do
      payload = { sub: admin.auth0_id_string }
      jwt_auth payload
    end

    it 'calls the render function with the correct parameters' do
      expect(Organization).to receive(:overview)
        .with(week_number: week_number, year: year, threshold_percentage: percentage_threshold)
        .and_return(overview)

      expect(controller).to receive(:render)
        .with(json: overview,
              serializer: Api::OrganizationOverviewSerializer,
              group: group)
        .and_call_original

      get :show, params: { group: group,
                           year: year,
                           week_number: week_number,
                           percentage_threshold: percentage_threshold }
    end

    it 'alsoes work without the year and week_number parameters' do
      get :show, params: { group: Person::STUDENT }
      expect(response.status).to eq(200)
    end

    it 'calls the overview generator function and store it' do
      expect(Organization).to receive(:overview)
        .with(week_number: week_number,
              year: year,
              threshold_percentage: percentage_threshold)
        .and_return(overview)

      get :show, params: { group: Person::STUDENT,
                           year: year,
                           week_number: week_number,
                           percentage_threshold: percentage_threshold }

      result = controller.instance_variable_get(:@organization_overview)

      expect(result).to eq(overview)
    end
  end
end
