# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguagesController, type: :controller do
  render_views
  let(:person) { FactoryBot.create(:person) }
  let(:protocol_subscription) { FactoryBot.create(:protocol_subscription, :requires_language_input, person: person) }
  let(:responseobj) { FactoryBot.create(:response, protocol_subscription: protocol_subscription) }

  before do
    cookie_auth(person)
  end

  describe 'GET #show' do
    it 'lists all available locales' do
      get :show
      expect(response).to have_http_status(200)
      %w[nl en fi de es pt].each do |locale|
        expect(response.body).to include("value=\"#{locale}\"")
      end
      expect(response.body).to include('Opslaan')
    end

    it 'shows the save button in Finnish for fi' do
      person.update!(locale: 'fi')
      get :show
      expect(response.body).to include('Tallenna')
    end

    it 'shows the save button in English for a locale without interface translations' do
      person.update!(locale: 'de')
      get :show
      expect(response.body).to include('Save')
    end
  end

  describe 'POST #change' do
    it 'sets the locale of the person to any available locale' do
      post :change, params: { locale: 'fi', r_id: responseobj.id }
      expect(person.reload.locale).to eq 'fi'
      expect(protocol_subscription.reload.has_language_input).to be true
    end

    it 'keeps nl and en working' do
      post :change, params: { locale: 'en', r_id: responseobj.id }
      expect(person.reload.locale).to eq 'en'
      post :change, params: { locale: 'nl', r_id: responseobj.id }
      expect(person.reload.locale).to eq 'nl'
    end

    it 'shows an error message when the locale cannot be updated' do
      allow_any_instance_of(Person).to receive(:update).and_return(false)
      post :change, params: { locale: 'en', r_id: responseobj.id }
      expect(flash[:alert]).to eq 'Kan de taalinstellingen niet bijwerken'
    end

    it 'falls back to en for an unavailable locale' do
      post :change, params: { locale: 'fr', r_id: responseobj.id }
      expect(person.reload.locale).to eq 'en'
    end
  end
end
