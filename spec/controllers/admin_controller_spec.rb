# frozen_string_literal: true
# frozen_string_literal: true

require 'rails_helper'

describe AdminController, type: :controller do
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

    it 'should require basic http auth' do
      routes_list.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    it 'should require the correct username' do
      basic_auth 'otherusername', 'admin'
      routes_list.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    it 'should require correct password' do
      basic_auth 'admin', 'otherpassword'
      routes_list.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    it 'response should be ok if authorized' do
      basic_auth 'admin', 'admin'
      routes_list.each do |route|
        get route
        expect(response).to be_ok
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
          expect(response.body).to eq 'Questionnaire with that name not found.'
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
