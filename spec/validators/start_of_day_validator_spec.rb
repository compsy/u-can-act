# frozen_string_literal: true

require 'rails_helper'

describe StartOfDayValidator do
  let(:protocol_subscription) { FactoryBot.build(:protocol_subscription) }

  it 'should return errors if the date is not midnight' do
    protocol_subscription.start_date = Time.new(2017, 4, 10, 0, 0, 1).in_time_zone
    expect(protocol_subscription).not_to be_valid
    expect(protocol_subscription.errors.messages).to have_key :start_date
    expect(protocol_subscription.errors.messages[:start_date]).to include('mag alleen middernacht zijn')
  end

  it 'should not return errors if the date is at midnight' do
    protocol_subscription.start_date = Time.new(2017, 4, 10, 0, 0, 0).in_time_zone
    expect(protocol_subscription).to be_valid
  end
end
