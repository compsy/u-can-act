# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguagesController, type: :controller do
  render_views
  let(:person) { FactoryBot.create(:person) }
  let(:protocol_subscription) { FactoryBot.create(:protocol_subscription, :requires_language_input, person: person) }
  let(:responseobj) { FactoryBot.create(:response, protocol_subscription: protocol_subscription) }
  let(:fi_questionnaire) do
    FactoryBot.create(:questionnaire, content: {
                        questions: [{ id: :v1, type: :number,
                                      title: { nl: 'Hoe oud ben je?', fi: 'Kuinka vanha olet?' } }],
                        scores: []
                      })
  end
  let(:fi_responseobj) do
    measurement = FactoryBot.create(:measurement, questionnaire: fi_questionnaire,
                                                  protocol: protocol_subscription.protocol)
    FactoryBot.create(:response, protocol_subscription: protocol_subscription, measurement: measurement)
  end

  before do
    cookie_auth(person)
  end

  describe 'GET #show' do
    it 'offers nl and en by default' do
      get :show
      expect(response).to have_http_status(200)
      %w[nl en].each { |locale| expect(response.body).to include("value=\"#{locale}\"") }
      %w[fi de es pt].each { |locale| expect(response.body).not_to include("value=\"#{locale}\"") }
      expect(response.body).to include('Opslaan')
    end

    it 'also offers the languages of the questionnaire of the response' do
      get :show, params: { r_id: fi_responseobj.id }
      %w[nl en fi].each { |locale| expect(response.body).to include("value=\"#{locale}\"") }
      %w[de es pt].each { |locale| expect(response.body).not_to include("value=\"#{locale}\"") }
    end

    it 'selects the locale of the person and shows the save button in Finnish for fi' do
      person.update!(locale: 'fi')
      get :show, params: { r_id: fi_responseobj.id }
      expect(response.body).to include('<input checked name="locale" type="radio" value="fi">')
      expect(response.body).to include('Tallenna')
    end

    it 'selects en when the locale of the person is not offered' do
      person.update!(locale: 'fi')
      get :show
      expect(response.body).to include('<input checked name="locale" type="radio" value="en">')
      expect(response.body).not_to include('Tallenna')
      expect(response.body).to include('Save')
    end

    it 'shows the save button in English for a locale without interface translations' do
      person.update!(locale: 'de')
      get :show
      expect(response.body).to include('Save')
    end
  end

  describe 'POST #change' do
    it 'sets the locale of the person to a language of the questionnaire' do
      post :change, params: { locale: 'fi', r_id: fi_responseobj.id }
      expect(person.reload.locale).to eq 'fi'
      expect(protocol_subscription.reload.has_language_input).to be true
    end

    it 'does not set a locale that the questionnaire is not available in' do
      post :change, params: { locale: 'fi', r_id: responseobj.id }
      expect(person.reload.locale).to eq 'en'
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
