# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::JwtApi::ProtocolController, type: :controller do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:person) { the_auth_user.person }
  let!(:no_protocols) { 5 }
  let!(:protocols) { FactoryBot.create_list(:protocol, no_protocols) }

  let!(:the_payload) do
    { ENV.fetch('SITE_LOCATION', nil) => {} }
  end

  describe 'unauthorized index' do
    it_behaves_like 'a jwt authenticated route', 'get', :index
  end

  describe 'unauthorized preview' do
    let!(:protocol) { FactoryBot.create(:protocol) }
    let!(:the_params) { { id: protocol.name } }
    it_behaves_like 'a jwt authenticated route', 'get', :preview
  end

  describe 'authorized' do
    before do
      the_payload[:sub] = the_auth_user.auth0_id_string
      jwt_auth the_payload
    end

    describe 'index' do
      it 'returns 200' do
        get :index
        expect(response.status).to be 200
      end

      it 'renders all available protocols in the platform' do
        get :index
        result = JSON.parse(response.body)
        expect(result.length).to eq(no_protocols)
      end
    end

    describe 'preview' do
      let(:protocol) { FactoryBot.create(:protocol) }
      let!(:measurement) do
        FactoryBot.create(:measurement,
                          period: 1.day,
                          open_from_offset: 0,
                          offset_till_end: nil,
                          protocol: protocol)
      end

      it 'renders a preview of a protocol when date is in future' do
        # Some date in the future
        start_date = Time.new(Time.zone.now.year + 2, 10, 10).in_time_zone
        end_date = TimeTools.increase_by_duration(start_date, 1.week)
        expected_times = [start_date,
                          TimeTools.increase_by_duration(start_date, 1.day),
                          TimeTools.increase_by_duration(start_date, 2.days),
                          TimeTools.increase_by_duration(start_date, 3.days),
                          TimeTools.increase_by_duration(start_date, 4.days),
                          TimeTools.increase_by_duration(start_date, 5.days),
                          TimeTools.increase_by_duration(start_date, 6.days)]
        get :preview, params: { id: protocol.name, start_date: start_date, end_date: end_date }
        expect(response.status).to eq 200
        result = JSON.parse(response.body)
        result.each_with_index do |entry, idx|
          expected_time = expected_times[idx]
          expect(entry).to eq({ 'open_from' => expected_time.to_json[1..-2], # strip the quotes
                                'questionnaire' => measurement.questionnaire.key })
        end
      end

      it 'renders just one response when the date is in the past' do
        # this is because it will use Time.zone.now as start_date when the start_date is in the past,
        # and it will use start_date + 1.hour as minimum end date. So since we have a measurement that
        # starts right at the start_date but has as period of one day, we will see one response in the preview.
        start_date = Time.new(2017, 10, 10).in_time_zone
        end_date = TimeTools.increase_by_duration(start_date, 1.week)
        noww = Time.zone.now
        get :preview, params: { id: protocol.name, start_date: start_date, end_date: end_date }
        expect(response.status).to eq 200
        result = JSON.parse(response.body)
        expect(result.length).to eq 1
        expect(result[0]['questionnaire']).to eq measurement.questionnaire.key
        expect(Time.zone.parse(result[0]['open_from'])).to be_within(5.seconds).of(noww)
      end

      it 'returns 404 if the protocol is not found' do
        get :preview, params: { id: 'unknown-protocol' }
        expect(response.status).to eq 404
        expect(response.body).to(include('Protocol with that name not found'))
      end
    end
  end
end
