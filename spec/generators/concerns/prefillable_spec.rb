# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'prefillable' do
  let(:person) { FactoryBot.create :person }
  let(:measurement) { FactoryBot.create :measurement, :prefilled }
  let!(:old_response) do
    FactoryBot.create :response, :completed, person: person, filled_out_by: person, measurement: measurement
  end
  let(:new_response) { FactoryBot.create :response, person: person, measurement: measurement }

  describe 'previous_response' do
    context 'when the measurement needs prefilling' do
      it 'returns the previous response' do
        expect(subject.previous_response(new_response)).to eq old_response
      end
      it 'does not return someone else\'s response' do
        another_person = FactoryBot.create :person
        FactoryBot.create :response,
                          :completed,
                          person: another_person,
                          filled_out_by: person,
                          measurement: measurement

        expect(subject.previous_response(new_response)).to eq old_response
      end
    end
    context 'when the measurement does not need prefilling' do
      let(:measurement) { FactoryBot.create :measurement }
      it 'returns nil even if a previous response exists' do
        expect(subject.previous_response(new_response)).to be_nil
      end
    end
  end

  describe 'previous_response_content' do
    context 'when the previous response has a response_content' do
      let!(:old_response) do
        FactoryBot.create :response, :completed, person: person, filled_out_by: person, measurement: measurement
      end
    end
    let(:expected_content) { { 'v1' => 'slecht', 'v2_brood' => 'true', 'v3' => '23' } }
    it 'returns the previous value of the given response and question' do
      expect(subject.previous_response_content(new_response)).to eq expected_content
    end
    context 'when the previous response does not have a response_content' do
      let!(:old_response) do
        FactoryBot.create :response, :completed, person: person, filled_out_by: person, measurement: measurement,
                          content: ''
      end
      it 'returns nil' do
        expect(subject.previous_response_content(new_response)).to be_nil
      end
    end
  end
end
