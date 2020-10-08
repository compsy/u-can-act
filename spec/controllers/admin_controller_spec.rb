# frozen_string_literal: true

require 'rails_helper'

describe AdminController, type: :controller do
  render_views
  describe "GET 'index'" do
    it 'initiates an team overview' do
      basic_auth 'admin', 'admin'
      get :index
    end
  end

  describe "GET 'routes'" do
    let(:routes_list) do
      %i[index person_export
         protocol_subscription_export
         invitation_set_export
         protocol_transfer_export]
    end

    def call_routes_and_expect_unauthorized(my_routes)
      my_routes.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    def call_routes_and_expect_ok(my_routes)
      my_routes.each do |route|
        get route
        expect(response).to be_ok
      end
    end

    it 'requires basic http auth' do
      call_routes_and_expect_unauthorized(routes_list)
    end

    it 'requires the correct username' do
      basic_auth 'otherusername', 'admin'
      call_routes_and_expect_unauthorized(routes_list)
    end

    it 'requires correct password' do
      basic_auth 'admin', 'otherpassword'
      call_routes_and_expect_unauthorized(routes_list)
    end

    it 'has an ok response if authorized' do
      basic_auth 'admin', 'admin'
      call_routes_and_expect_ok(routes_list)
    end

    context 'toggleable routes' do
      let(:routes_list) do
        [
          {
            route: :identifier_export,
            toggle: :allow_identifier_export
          }
        ]
      end

      it 'requires basic http auth' do
        call_routes_and_expect_unauthorized(routes_list.pluck(:route))
      end

      it 'requires the correct username' do
        basic_auth 'otherusername', 'admin'
        call_routes_and_expect_unauthorized(routes_list.pluck(:route))
      end

      it 'requires a correct password' do
        basic_auth 'admin', 'otherpassword'
        call_routes_and_expect_unauthorized(routes_list.pluck(:route))
      end

      context 'with an allowed action' do
        it 'response should not be ok if authorized' do
          basic_auth 'admin', 'admin'
          routes_list.each do |current_route|
            expect(Rails.application.config.settings.feature_toggles)
              .to receive(current_route[:toggle])
              .and_return(true)
            get current_route[:route]
            expect(response).to be_ok
          end
        end
      end

      context 'with a disallowed action' do
        it 'response should not be ok if authorized' do
          basic_auth 'admin', 'admin'
          routes_list.each do |route|
            expect(Rails.application.config.settings.feature_toggles)
              .to receive(route[:toggle])
              .and_return(false)
            expect { get route[:route] }
              .to raise_error(RuntimeError, /Exporting [a-z]* is currently not allowed\./)
          end
        end
      end
    end

    context 'questionnaire routes' do
      let(:routes_list) { %i[questionnaire_export response_export] }
      let!(:questionnaire) { FactoryBot.create(:questionnaire, name: 'my-questionnaire') }

      it 'renders an error when the questionnaire cannot be found' do
        basic_auth 'admin', 'admin'
        routes_list.each do |route|
          get route, params: { id: 'some_questionnaire' }
          expect(response.status).to eq 404
          expect(response).to render_template(layout: 'application')
          expect(response.body).to include 'Questionnaire with that name not found.'
        end
      end

      it 'is okay when the questionnaire is found' do
        basic_auth 'admin', 'admin'
        routes_list.each do |route|
          get route, params: { id: 'my-questionnaire' }
          expect(response.status).to eq 200
        end
      end
    end
  end
end
