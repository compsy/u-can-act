# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OneTimeResponse, type: :model do
  it 'has a valid factory' do
    otr = FactoryBot.create(:one_time_response)
    expect(otr).to be_valid
  end

  describe 'protocol' do
    it 'validates the presence of the protocol' do
      otr = FactoryBot.create(:one_time_response)
      otr.protocol = nil
      expect(otr).not_to be_valid
    end

    it 'is able to access the protocol' do
      otr = FactoryBot.create(:one_time_response)
      expect(otr.protocol).not_to be_nil
    end
  end

  describe 'token' do
    it 'is not valid without a token' do
      otr = FactoryBot.create(:one_time_response)
      otr.token = nil
      expect(otr).not_to be_valid
    end

    it 'initializes the token if it is not provided' do
      otr = FactoryBot.create(:one_time_response)
      expect(otr.token).not_to be_nil
    end

    it 'initializes the token with an alpha numeric string of the correct size' do
      otr = FactoryBot.create(:one_time_response)
      expect(otr.token.length).to eq described_class::TOKEN_LENGTH
      expect(otr.token).to match(/[a-z0-9]*/)
    end

    it 'does not override a user provided token' do
      mytoken = 'mytoken'
      otr = FactoryBot.create(:one_time_response, token: mytoken)
      expect(otr.token).to eq mytoken
    end

    it 'is unique' do
      otr = FactoryBot.create(:one_time_response)
      otr2 = FactoryBot.create(:one_time_response)
      otr2.token = otr.token
      expect(otr2).not_to be_valid
    end
  end

  describe 'database validations' do
    it 'does not allow a null protocol' do
      otr = FactoryBot.create(:one_time_response)
      otr.protocol = nil
      expect { otr.save(validate: false) }.to raise_error(
        ActiveRecord::StatementInvalid,
        /PG::NotNullViolation: ERROR:  null value in column "protocol_id"/
      )
    end

    it 'does not allow a null token' do
      otr = FactoryBot.create(:one_time_response)
      otr.token = nil
      expect { otr.save(validate: false) }.to raise_error(
        ActiveRecord::StatementInvalid,
        /PG::NotNullViolation: ERROR:  null value in column "token"/
      )
    end

    it 'does not allow a duplicate tokens' do
      otr = FactoryBot.create(:one_time_response)
      otr2 = FactoryBot.create(:one_time_response)
      otr2.token = otr.token
      expect { otr2.save(validate: false) }.to raise_error(
        ActiveRecord::StatementInvalid,
        /PG::UniqueViolation: ERROR:  duplicate key value violates unique/
      )
    end
  end

  describe 'redirect_url' do
    let(:protocol) { FactoryBot.create(:protocol, :with_measurements) }
    let(:otr) { FactoryBot.create(:one_time_response, protocol: protocol) }
    let(:person) { FactoryBot.create(:person) }
    let(:mentor) { FactoryBot.create(:mentor) }
    let(:invitation_token) { FactoryBot.create(:invitation_token) }

    before :each do
      expect(person.protocol_subscriptions).to be_blank
    end

    it 'returns the url for the otr' do
      otr.subscribe_person(person)
      person.reload
      result = otr.redirect_url(person)
      expect(result).to_not be_blank
      expect(result).to start_with '?q='
    end

    it 'also creates a url if not subscribed' do
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                person: person,
                                                start_date: 1.day.ago)
      response = FactoryBot.create(:response,
                                   protocol_subscription: protocol_subscription,
                                   measurement: protocol.measurements.first,
                                   open_from: 1.minute.ago)
      result = otr.redirect_url(person)
      invitation_set = InvitationSet.last
      expect(invitation_set.responses).to_not be_blank
      expect(invitation_set.responses.first).to eq(response)
      expect(result).to_not be_blank
      expect(result).to start_with '?q='
    end

    it 'also works with one time responses that are filled out for someone else' do
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                person: person,
                                                start_date: 1.day.ago,
                                                filling_out_for_id: FactoryBot.create(:person).id)
      response = FactoryBot.create(:response,
                                   protocol_subscription: protocol_subscription,
                                   measurement: protocol.measurements.first,
                                   open_from: 1.minute.ago)
      result = otr.redirect_url(person)
      invitation_set = InvitationSet.last
      expect(invitation_set.responses).to_not be_blank
      expect(invitation_set.responses.first).to eq(response)
      expect(result).to_not be_blank
      expect(result).to start_with '?q='
    end
  end

  describe 'subscribe_person' do
    let(:protocol) { FactoryBot.create(:protocol, :with_measurements) }
    let(:otr) { FactoryBot.create(:one_time_response, protocol: protocol) }
    let(:person) { FactoryBot.create(:person) }
    let(:mentor) { FactoryBot.create(:mentor) }

    before :each do
      expect(person.protocol_subscriptions).to be_blank
    end

    it 'should subscribe the person to the protocol' do
      otr.subscribe_person(person)
      person.reload
      expect(person.protocol_subscriptions).to_not be_blank
      expect(person.protocol_subscriptions.length).to eq 1
      expect(person.protocol_subscriptions.first.protocol).to eq otr.protocol
    end

    it 'should also set the mentor' do
      otr.subscribe_person(person, mentor)
      person.reload
      expect(person.protocol_subscriptions).to_not be_blank
      expect(person.protocol_subscriptions.length).to eq 1
      expect(person.protocol_subscriptions.first.person).to eq person
      expect(person.protocol_subscriptions.first.filling_out_for).to eq mentor
    end

    it 'should also prepare the responses' do
      expect(person.all_my_open_responses).to be_blank
      otr.subscribe_person(person)
      person.reload
      expect(person.all_my_open_responses).to_not be_blank
      expect(person.my_open_one_time_responses).to_not be_blank
    end
  end
end
