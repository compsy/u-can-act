# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::CookieAndJwtApi::ProtocolSubscriptionsController, type: :controller do
  render_views
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:protocol_subscription) { FactoryBot.create(:protocol_subscription, person: the_auth_user.person) }
  let(:test_response) do
    FactoryBot.create(:response,
                      protocol_subscription: protocol_subscription,
                      completed_at: 10.minutes.ago)
  end

  let!(:protocol_subscriptions) do
    FactoryBot.create_list(:protocol_subscription, 4, person: protocol_subscription.person)
  end

  let(:other_response) { FactoryBot.create(:response) }

  describe 'show' do
    describe 'without cookie' do
      it 'returns 401 if no protocol_subscription is available' do
        get :show, params: { id: protocol_subscription.id }
        expect(response.status).to eq 401
        expect(response.body).to include 'niet ingelogd'
      end
    end

    describe 'with auth' do
      before do
        cookie_auth(protocol_subscription.person)
      end

      it 'sets the correct env vars if the response is available' do
        get :show, params: { id: protocol_subscription.id }
        expect(response.status).to eq 200
        expect(controller.instance_variable_get(:@protocol_subscription)).to eq(protocol_subscription)
      end

      it 'renders the correct json object' do
        allow(controller).to receive(:render)
          .with(json: protocol_subscription,
                serializer: Api::ProtocolSubscriptionSerializer)
          .and_call_original

        get :show, params: { id: protocol_subscription.id }
        expect(response.status).to eq 200
      end

      it 'throws a 403 if the user is not allowed to access' do
        get :show, params: { id: other_response.protocol_subscription.id }
        expect(response.status).to eq 403
        expect(response.body).to match 'U heeft geen toegang tot deze protocolsubscriptie'
      end

      it 'throws a 404 if the protocol subscription does not exist' do
        get :show, params: { id: 192_301 }
        expect(response.status).to eq 404
        expect(response.body).to include 'Protocol subscription met dat ID niet gevonden'
      end
    end
  end

  describe 'create' do
    describe 'without cookie' do
      it 'returns 401 if the user is not logged in' do
        post :create, params: { start_time: '0', protocol_name: protocol_subscription.protocol.name }
        expect(response.status).to eq 401
        expect(response.body).to include 'niet ingelogd'
      end
    end

    describe 'with auth' do
      before do
        cookie_auth(protocol_subscription.person)
      end
      let(:protocol) { FactoryBot.create(:protocol) }
      let(:time) { Time.zone.now.change(usec: 0) }
      let(:prot_name) { protocol.name }

      it 'calls the SubscribeToProtocol with a start_date' do
        expect(SubscribeToProtocol).to receive(:run!).with(
          protocol_name: prot_name,
          person: the_auth_user.person,
          start_date: time,
          only_if_not_subscribed: true
        ).and_return true

        post :create, params: { protocol_name: prot_name,
                                start_date: time }
        expect(response.status).to eq 201
      end

      it 'starts the protocol subscription with a start_time' do
        post :create, params: { protocol_name: prot_name,
                                start_time: '900' }
        expect(response.status).to eq 201
        expected = TimeTools.increase_by_duration(Time.zone.now.beginning_of_day, 1.day + 900.seconds)
        expect(ProtocolSubscription.last.start_date).to be_within(3.seconds).of(expected)
      end

      it 'works with a start_time that is zero' do
        post :create, params: { protocol_name: prot_name,
                                start_time: '0' }
        expect(response.status).to eq 201
        expected = TimeTools.increase_by_duration(Time.zone.now.beginning_of_day, 1.day)
        expect(ProtocolSubscription.last.start_date).to be_within(3.seconds).of(expected)
      end

      it 'starts the protocol right now if we don\'t specify a start_time or start_date' do
        post :create, params: { protocol_name: prot_name }
        expect(response.status).to eq 201
        expected = Time.zone.now
        expect(ProtocolSubscription.last.start_date).to be_within(3.seconds).of(expected)
      end
    end
  end

  describe 'destroy' do
    describe 'without cookie' do
      it 'returns 401 if the user is not logged in' do
        delete :destroy, params: { id: protocol_subscription.id }
        expect(response.status).to eq 401
        expect(response.body).to include 'niet ingelogd'
      end
    end

    describe 'with auth' do
      before do
        cookie_auth(protocol_subscription.person)
      end
      let(:protocol) { FactoryBot.create(:protocol) }
      let(:time) { Time.zone.now.change(usec: 0) }
      let(:prot_name) { protocol.name }

      it 'destroys the protocol subscription of itself' do
        expect do
          delete :destroy, params: { id: protocol_subscription.id }
        end.to change(ProtocolSubscription, :count).by(-1)
        expect(response.status).to eq 200
      end

      it 'destroys the protocol subscription that it is mentor of' do
        other_person = FactoryBot.create(:person)
        # this protocol subscription belongs to someone else:
        protocol_subscription.update!(person: other_person, filling_out_for: other_person)
        # Make sure that the current_auth_user.person is seen as a mentor of other_person,
        # by creating a "mentor" protocol subscription where the mentor fills out a protocol subscription
        # for this person.
        FactoryBot.create(:protocol_subscription, person: the_auth_user.person, filling_out_for: other_person)
        expect do
          delete :destroy, params: { id: protocol_subscription.id }
        end.to change(ProtocolSubscription, :count).by(-1)
        expect(response.status).to eq 200
      end

      it 'does not destroy protocol subscriptions that it does not own' do
        protocol_subscription.update!(person_id: FactoryBot.create(:person).id)
        expect do
          delete :destroy, params: { id: protocol_subscription.id }
        end.not_to change(ProtocolSubscription, :count)
        expect(response.status).to eq 403
      end
    end
  end
end
