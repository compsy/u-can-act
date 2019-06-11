# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MentorOverviewController, type: :controller do
  render_views
  let(:student) { FactoryBot.create(:student) }
  let(:mentor) { FactoryBot.create(:mentor) }

  describe 'GET #index' do
    describe 'Authentication' do
      it 'throws if there is no logged in person' do
        expect(controller).to receive(:current_user).at_least(:once).and_return(nil)
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Je hebt geen toegang tot deze vragenlijst.')
      end

      it 'requires a token with response id that exists' do
        cookie_auth(student)
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Niet ingelogd als mentor.')
      end

      it 'works when a mentor is logged in' do
        cookie_auth(mentor)
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'with a correct call' do
      before do
        cookie_auth(mentor)
        [mentor, student].each do |person_to_fill_out_for|
          prot_sub = FactoryBot.create(:protocol_subscription,
                                       start_date: 1.week.ago.at_beginning_of_day,
                                       person: mentor,
                                       filling_out_for: person_to_fill_out_for)
          FactoryBot.create(:response, protocol_subscription: prot_sub,
                                       open_from: 1.hour.ago)
        end
        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'sets the mentor its protocol subscriptions' do
        prot_sub = controller.instance_variable_get(:@my_protocol_subscriptions)
        expect(prot_sub).not_to be_blank
        expect(prot_sub.length).to eq 1
        prot_sub = prot_sub.first
        expect(prot_sub.filling_out_for).to eq(mentor)
      end

      it 'sets the supervised students protocol subscriptions' do
        prot_sub = controller.instance_variable_get(:@student_protocol_subscriptions)
        expect(prot_sub).not_to be_blank
        expect(prot_sub.length).to eq 1
        prot_sub = prot_sub.first
        expect(prot_sub.filling_out_for).to eq(student)
      end

      it 'sets the mentor layout' do
        use_mentor_layout = controller.instance_variable_get(:@use_mentor_layout)
        expect(use_mentor_layout).not_to be_blank
        expect(use_mentor_layout).to be_truthy
      end
    end
  end
end
