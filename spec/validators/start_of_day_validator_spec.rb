# frozen_string_literal: true

require 'rails_helper'

describe StartOfDayValidator do
  class Validatable
    include ActiveModel::Validations
    validates :start_date, start_of_day: true
    attr_accessor :start_date
  end

  let(:record) { Validatable.new }

  it 'should return errors if the date is not midnight' do
    record.start_date = Time.new(2017, 4, 10, 0, 0, 1).in_time_zone

    expect(record).not_to be_valid
    expect(record.errors.messages).to have_key :start_date
    expect(record.errors.messages[:start_date]).to include('mag alleen middernacht zijn')
  end

  it 'should not return errors if the date is at midnight' do
    record.start_date = Time.new(2017, 4, 10, 0, 0, 0).in_time_zone.beginning_of_day
    expect(record).to be_valid
  end
end
