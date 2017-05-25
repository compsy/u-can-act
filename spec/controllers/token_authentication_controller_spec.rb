require 'rails_helper'

RSpec.describe TokenAuthenticationController, type: :controller do

  describe "GET #show", focus: true do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(404)
      expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
    end

    it 'requires a q parameter that exists' do
      get :show, params: { q: 'something' }
      expect(response).to have_http_status(404)
      expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
    end

    it 'requires a response that is not filled out yet' do
      responseobj = FactoryGirl.create(:response, :completed)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      get :show, params: { q: invitation_token.token }
      expect(response).to have_http_status(404)
      expect(response.body).to include('Je hebt deze vragenlijst al ingevuld.')
    end

    it 'requires a q parameter that is not expired' do
      invitation_token = FactoryGirl.create(:invitation_token)
      get :show, params: { q: invitation_token.token }
      expect(response).to have_http_status(404)
      expect(response.body).to include('Deze vragenlijst kan niet meer ingevuld worden.')
    end

    it 'should redirect to the questionnaire controller if the person is a student' do
      person_type = :student
      person = FactoryGirl.create(:person, person_type)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 person: person)
      responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      get :show, params: { q: invitation_token.token }
      expect(response).to have_http_status(302)
      expect(response.location).to_not eq(mentor_overview_url(q: invitation_token.token))
      expect(response.location).to eq(questionnaire_url(q: invitation_token.token))
    end

    it 'should redirect to the mentor controller if the person is a mentor' do
      person_type = :mentor
      person = FactoryGirl.create(:person, person_type)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 person: person)
      responseobj = FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      get :show, params: { q: invitation_token.token }
      expect(response).to have_http_status(302)
      expect(response.location).to eq(mentor_overview_url(q: invitation_token.token))
    end

    describe 'should set the correct cookie' do
      let(:person_type) {:mentor}
      let(:person) {FactoryGirl.create(:person, person_type)}
      let(:protocol_subscription) {FactoryGirl.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                person: person)}
      let(:responseobj) {FactoryGirl.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)}

      before :each do
        invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
        get :show, params: { q: invitation_token.token }
        expect(cookies.signed).to_not be_blank
      end

      it 'should set the response id cookie' do
        expected = {
          'person_id' => person.id.to_s,
          'response_id' =>  responseobj.id.to_s,
          'type' =>  person.type.to_s
        }.to_json

        expect(cookies.signed[described_class::COOKIE_LOCATION]).to_not be_nil
        expect(cookies.signed[described_class::COOKIE_LOCATION]).to be_a String
        expect(cookies.signed[described_class::COOKIE_LOCATION]).to eq expected
      end
    end
  end
end
