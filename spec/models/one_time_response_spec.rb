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
end
