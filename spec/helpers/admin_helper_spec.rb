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
end
