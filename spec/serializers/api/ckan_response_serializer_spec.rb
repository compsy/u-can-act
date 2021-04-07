# frozen_string_literal: true

require 'rails_helper'

describe Api::CkanResponseSerializer do
  let(:response) { FactoryBot.create :response, :completed }

  subject(:json) { Api::CkanResponseSerializer.new(response).as_json.with_indifferent_access }

  it 'contains the correct top-level fields' do
    expect(json.keys).to match_array %w[dataset resource records schema]
  end

  describe 'dataset' do
    it 'matches the UMO dataset' do
      expect(json[:dataset]).to eq ENV['CKAN_DATASET']
    end
  end

  describe 'resource' do
    it 'contains the correct resource name' do
      expect(json[:resource][:name]).to eq response.measurement.questionnaire.name
    end
  end

  describe 'schema' do
    describe 'primaryKey' do
      it 'matches the expected value' do
        expect(json[:schema][:primaryKey]).to eq :uuid
      end
    end
    describe 'columns' do
      it 'contains all the question definitions in the questionnaire' do
        expect(json[:schema][:columns].pluck(:id)).to match_array %i[uuid v1 v2 v3 v4_1 v4_2 v4_3 v4_4 v4_5]
      end
      let(:expected_types) { %i[text json date time timestamp int float bool] }
      describe 'type' do
        it 'matches one of the ckan types' do
          json[:schema][:columns].each do |column|
            expect(expected_types).to include column[:type]
          end
        end
      end
      describe 'label' do
        it 'contains a non-empty string' do
          json[:schema][:columns].filter { |c| c[:id] != :uuid }.each do |column|
            expect(column[:info][:label]).to be_a String
          end
        end
      end
    end
  end

  describe 'records' do
    it 'contains an array with one response' do
      expect(json[:records].count).to eq 1
    end

    it 'contains an uuid' do
      expect(json[:records].first[:uuid]).not_to be_nil
    end
  end
end
