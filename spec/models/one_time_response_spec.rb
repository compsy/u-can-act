# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OneTimeResponse, type: :model do
  it 'should have a valid factory' do
    otr = FactoryBot.build(:one_time_response)
    expect(otr).to be_valid
  end

  describe 'protocol' do
    it 'should validate the presence of the protocol' do
      otr = FactoryBot.build(:one_time_response)
      otr.protocol = nil
      expect(otr).to_not be_valid
    end

    it 'should be able to access the protocol' do
      otr = FactoryBot.build(:one_time_response)
      expect(otr.protocol).to_not be_nil
    end
  end

  describe 'token' do
    it 'should not be valid without a token' do
      otr = FactoryBot.build(:one_time_response)
      otr.token = nil
      expect(otr).to_not be_valid
    end

    it 'should initialize the token if it is not provided' do
      otr = FactoryBot.build(:one_time_response)
      expect(otr.token).to_not be_nil
    end

    it 'should initialize the token with an alpha numeric string of the correct size' do
      otr = FactoryBot.build(:one_time_response)
      expect(otr.token.length).to eq described_class::TOKEN_LENGTH
      expect(otr.token).to match /[a-z0-9]*/
    end

    it 'should not override a user provided token' do
      mytoken = 'mytoken'
      otr = FactoryBot.build(:one_time_response, token: mytoken)
      expect(otr.token).to eq mytoken
    end
  end

  describe 'database validations' do
    it 'should not allow a null protocol' do
      otr = FactoryBot.build(:one_time_response, protocol: nil)
      expect { otr.save(validate: false) }.to raise_error(
        ActiveRecord::StatementInvalid,
        /PG::NotNullViolation: ERROR:  null value in column "protocol_id"/
      )
    end

    it 'should not allow a null token' do
      otr = FactoryBot.build(:one_time_response)
      otr.token = nil
      expect { otr.save(validate: false) }.to raise_error(
        ActiveRecord::StatementInvalid,
        /PG::NotNullViolation: ERROR:  null value in column "token"/
      )
    end
  end
end
