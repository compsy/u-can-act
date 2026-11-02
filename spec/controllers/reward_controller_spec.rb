# frozen_string_literal: true

require 'rails_helper'

describe RewardController, type: :controller do
  render_views
  it_behaves_like 'an is_logged_in concern', :index, {}
  describe 'GET /klaar' do
    let(:student) { FactoryBot.create(:student) }

    describe 'locale' do
      it 'renders the page in the language of the person' do
        student.update!(locale: 'de')
        cookie_auth(student)
        get :index
        expect(response.body).to include('Sie können diese Seite erst nach dem Ausfüllen eines Fragebogens ansehen.')
        expect(response.body).to include('<meta content="de" name="i18n-locale">')
        expect(response.body).to include('<html lang="de">')
      end

      it 'uses the browser language when nobody is logged in' do
        request.headers['Accept-Language'] = 'sv-SE,fi;q=0.8,en;q=0.5'
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Et ole kirjautunut sisään.')
      end

      it 'uses nl when nobody is logged in and the browser language is not supported' do
        request.headers['Accept-Language'] = 'sv-SE'
        get :index
        expect(response.body).to include('Je bent niet ingelogd.')
      end
    end

    describe 'with logged in student' do
      before do
        cookie_auth(student)
      end

      it 'requires a questionnaire to be filled out id' do
        get :index
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Je kan deze pagina alleen bekijken na het invullen van een vragenlijst.')
      end

      it 'requires a completed response and thus not work with a not-completed response' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: student)
        FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        get :index
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Je kan deze pagina alleen bekijken na het invullen van een vragenlijst.')
      end

      it 'does not give an error when the response is completed' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: student)
        FactoryBot.create(:response, :completed, protocol_subscription: protocol_subscription)

        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'loads the last completed response for displaying the reward' do
        responseobj = FactoryBot.create(:response, :completed)
        expect_any_instance_of(Person).to receive(:last_completed_response).and_return(responseobj)

        get :index
        expect(controller.instance_variable_get(:@response)).to eq responseobj
      end
    end
  end
end
