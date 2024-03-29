# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::JwtApi::OneTimeResponseController, type: :controller do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:person) { the_auth_user.person }
  let(:protocol) { FactoryBot.create(:protocol, :with_measurements) }
  let(:protocol_subscription) do
    FactoryBot.create(:protocol_subscription, person: the_auth_user.person, protocol: protocol)
  end
  let(:test_response) do
    FactoryBot.create(:response,
                      protocol_subscription: protocol_subscription,
                      completed_at: 10.minutes.ago)
  end

  let!(:protocol_subscriptions) do
    FactoryBot.create_list(:protocol_subscription, 4, person: protocol_subscription.person)
  end

  let!(:the_payload) do
    {
      'sub' => the_auth_user.auth0_id_string,
      ENV.fetch('SITE_LOCATION', nil) => {
        'access_level' => ['user']
      }
    }
  end

  it_behaves_like 'a jwt authenticated route', 'get', :index

  describe 'with authentication' do
    before do
      jwt_auth the_payload
    end

    describe 'GET /:token' do
      let(:thetoken) { 'theotrtoken' }
      let!(:otr) { FactoryBot.create(:one_time_response, token: thetoken, protocol: protocol) }

      it 'should redirect the user to the correct page' do
        get :show, params: { otr: thetoken }
        expect(response.status).to eq 302
        expect(response.location).to start_with 'http://test.host?q='
      end

      it 'should render a 404 if the otr is not found' do
        get :show, params: { otr: 'nonexistingtoken' }
        expect(response.status).to eq 404
      end

      it 'should subscribe the person to the OTR protocol' do
        person.protocol_subscriptions.destroy_all
        expect(person.protocol_subscriptions).to be_blank
        get :show, params: { otr: thetoken }
        person.reload
        expect(response.status).to_not eq 404
        expect(person.protocol_subscriptions).to_not be_blank
        expect(person.protocol_subscriptions.length).to eq 1
        expect(person.protocol_subscriptions.first.protocol).to eq otr.protocol
      end

      it 'should not subscribe the person if the OTR protocol is restricted' do
        person.protocol_subscriptions.destroy_all
        expect(person.protocol_subscriptions).to be_blank
        otr.update!(restricted: true)
        get :show, params: { otr: thetoken }
        person.reload
        expect(response.status).to eq 404
        expect(response.body).to match 'You must have an active protocol subscription to this protocol ' \
                                       'to be allowed to fill it out.'
        expect(person.protocol_subscriptions).to be_blank
      end

      it 'should redirect if a person is already subscribed for a restricted OTR protocol' do
        otr.update!(restricted: true)
        expect(person.protocol_subscriptions).to_not be_blank
        get :show, params: { otr: thetoken }
        person.reload
        expect(response.status).to_not eq 404
      end
    end

    describe 'GET /' do
      let(:number_of_otrs) { 10 }
      let!(:otrs) { FactoryBot.create_list(:one_time_response, number_of_otrs) }
      it 'should head a 200 for the call' do
        get :index
        expect(response.status).to eq 200
      end

      it 'should list all OTRs' do
        get :index
        result = JSON.parse(response.body)
        expect(result.length).to eq number_of_otrs
        tokens = otrs.map(&:token)
        result.each do |otr_result|
          expect(tokens).to include(otr_result['token'])
        end
      end
    end
  end
end
