# frozen_string_literal: true

require 'rails_helper'

describe AdminHelper do
  describe 'file_headers' do
    it 'should set the correct file headers' do
      myheaders = double('headers')
      expect(myheaders).to receive(:[]=).with('Content-Type', 'text/csv')
      expect(myheaders).to receive(:[]=).with('Content-Disposition', 'attachment; filename="hello.csv"')
      expect(controller).to receive(:headers).twice.and_return(myheaders)
      helper.file_headers!('hello')
    end
  end

  describe 'streaming_headers' do
    it 'should set the correct streaming headers' do
      myheaders = double('headers')
      expect(myheaders).to receive(:[]=).with('X-Accel-Buffering', 'no')
      expect(myheaders).to receive(:[]).with('Cache-Control')
      expect(myheaders).to receive(:[]=).with('Cache-Control', 'no-cache')
      expect(myheaders).to receive(:delete).with('Content-Length')
      expect(controller).to receive(:headers).exactly(3).times.and_return(myheaders)
      helper.streaming_headers!
    end
  end

  describe 'date_string' do
    it 'should return today\'s date' do
      expect(helper.date_string).to eq Time.zone.now.to_date.to_s
    end
  end

  describe 'idify' do
    it 'should work with a single parameter' do
      expect(helper.idify('hello')).to eq 'hello'
      expect(helper.idify('Hello ')).to eq 'hello'
      expect(helper.idify('hel lo')).to eq 'hel_lo'
      expect(helper.idify('hel  lo')).to eq 'hel_lo'
      expect(helper.idify('hel,lo')).to eq 'hel_lo'
      expect(helper.idify('hel:lo')).to eq 'hel_lo'
      expect(helper.idify('ProtSub')).to eq 'protsub'
    end
    it 'should work with multiple parameters' do
      expect(helper.idify('hello', 'goodbye')).to eq 'hello_goodbye'
      expect(helper.idify('Hello', ' goodBye')).to eq 'hello_goodbye'
    end
  end

  describe 'questionnaire_select_options' do
    it 'should return the names of questionnaires' do
      questionnaires = [
        FactoryBot.create(:questionnaire, name: 'firstname'),
        FactoryBot.create(:questionnaire, name: 'secondname')
      ]
      expected = [['Selecteer een vragenlijst...', ''], %w[firstname firstname], %w[secondname secondname]]
      expect(helper.questionnaire_select_options(questionnaires)).to eq expected
    end
    it 'should work with an empty list' do
      expect(helper.questionnaire_select_options([])).to eq [['Selecteer een vragenlijst...', '']]
    end
  end

  describe 'overview' do
    let(:instance_var) do
      [
        {
          name: 'Organization1',
          data: {
            Person::STUDENT => {
              completed: 10,
              total: 90
            },
            Person::MENTOR => {
              completed: 11,
              total: 95
            }
          }
        },
        {
          name: 'Organization2',
          data: {
            Person::STUDENT => {
              completed: 0,
              total: 20
            },
            Person::MENTOR => {
              completed: 21,
              total: 50
            }
          }
        }
      ]
    end

    it 'should gracefully return an empty array if the @organization_overview var is not set' do
      result = helper.overview('whatever')
      expect(result).to be_empty
      expect(result).to be_a Array
    end

    it 'should return a hash with the correct stats for a specified group' do
      instance_variable_set(:@organization_overview, instance_var)
      [Person::STUDENT, Person::MENTOR].each do |group|
        result = helper.overview(group)
        expect(result.length).to eq 2
        (0..1).each do |idx|
          expect(result[idx][:name]).to eq instance_var[idx][:name]
          expect(result[idx][:completed]).to eq instance_var[idx][:data][group][:completed]

          percentage = instance_var[idx][:data][group][:completed].to_d /
                       instance_var[idx][:data][group][:total].to_d * 100.0
          expect(result[idx][:percentage_completed]).to eq percentage.round
        end
      end
    end
  end
end
