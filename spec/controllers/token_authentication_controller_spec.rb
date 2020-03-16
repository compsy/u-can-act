# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenAuthenticationController, type: :controller do
  render_views
  describe 'GET #show' do
    describe 'Error checking' do
      it 'returns http not found when not given any params' do
        get :show
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Gebruiker / Vragenlijst niet gevonden.')
      end

      it 'requires a q parameter that is valid' do
        get :show, params: { q: 'something' }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Je bent niet bevoegd om deze vragenlijst te zien.')
      end

      it 'requires a q parameter that is not expired' do
        responseobj = FactoryBot.create(:response, :invited)
        invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        expect_any_instance_of(InvitationToken).to receive(:expired?).and_return(true)
        get :show, params: { q: identifier }
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Deze link is niet meer geldig.')
      end
    end

    describe 'redirects to the questionnaire controller' do
      let(:person) { FactoryBot.create(:person) }
      let(:mentor) { FactoryBot.create(:mentor) }

      def prepare_spec(protocol_subscription)
        responseobj = FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription,
                                                             open_from: 1.hour.ago)
        invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        get :show, params: { q: identifier }
        expect(response).to have_http_status(:found)
        expect(response.location).not_to eq(mentor_overview_index_url)
        [response, responseobj]
      end

      it 'redirects to the questionnaire controller if everything checks out' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: person)
        response, responseobj = prepare_spec(protocol_subscription)
        expect(response.location).to end_with(preference_questionnaire_index_path(uuid: responseobj.uuid))
      end

      it 'redirects to the index of questionnaire controller if everything checks out and we are a mentor' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  filling_out_for: person,
                                                  person: mentor)
        response, _responseobj = prepare_spec(protocol_subscription)
        expect(response.location).to end_with(questionnaire_index_path)
      end
    end

    describe 'should set the correct cookie' do
      let(:person_type) { :mentor }
      let(:person) { FactoryBot.create(person_type) }
      let(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription,
                          start_date: 1.week.ago.at_beginning_of_day,
                          person: person)
      end
      let(:responseobj) do
        FactoryBot.create(:response,
                          :invited,
                          protocol_subscription: protocol_subscription,
                          open_from: 1.hour.ago)
      end
      let(:invitation_token) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

      it 'sets the response id cookie' do
        expected = { person_id: person.external_identifier.to_s }

        expect(controller)
          .to receive(:store_verification_cookie).and_return true

        expect(CookieJar)
          .to receive(:set_or_update_cookie)
          .with(instance_of(ActionDispatch::Cookies::SignedCookieJar), expected)
        identifier = "#{responseobj.protocol_subscription.person.external_identifier}#{invitation_token.token_plain}"
        get :show, params: { q: identifier }
      end
    end
  end
end
