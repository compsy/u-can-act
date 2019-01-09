# frozen_string_literal: true

require 'rails_helper'

describe AdminController, type: :controller do
  render_views
  describe "GET 'index'" do
    it 'should initiate an team overview' do
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

    it 'should require basic http auth' do
      call_routes_and_expect_unauthorized(routes_list)
    end

    it 'should require the correct username' do
      basic_auth 'otherusername', 'admin'
      call_routes_and_expect_unauthorized(routes_list)
    end

    it 'should require correct password' do
      basic_auth 'admin', 'otherpassword'
      call_routes_and_expect_unauthorized(routes_list)
    end

    it 'response should be ok if authorized' do
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

      it 'should require basic http auth' do
        call_routes_and_expect_unauthorized(routes_list.map { |entry| entry[:route] })
      end

      it 'should require the correct username' do
        basic_auth 'otherusername', 'admin'
        call_routes_and_expect_unauthorized(routes_list.map { |entry| entry[:route] })
      end

      it 'should require correct password' do
        basic_auth 'admin', 'otherpassword'
        call_routes_and_expect_unauthorized(routes_list.map { |entry| entry[:route] })
      end

      context 'with an allowed action' do
        it 'response should not be ok if authorized' do
          basic_auth 'admin', 'admin'
          routes_list.each do |route|
            expect(Rails.application.config.settings.feature_toggles)
              .to_receive(routes_list[:toggle])
              .and_return(true)
            get route[:route]
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

      it 'should render an error when the questionnaire cannot be found' do
        basic_auth 'admin', 'admin'
        routes_list.each do |route|
          get route, params: { id: 'some_questionnaire' }
          expect(response.status).to eq 404
          expect(response).to render_template(layout: 'application')
          expect(response.body).to include 'Questionnaire with that name not found.'
        end
      end

      it 'should be okay when the questionnaire is found' do
        basic_auth 'admin', 'admin'
        routes_list.each do |route|
          get route, params: { id: 'my-questionnaire' }
          expect(response.status).to eq 200
        end
      end
    end
  end
end
