# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SettingsController, type: :controller do
  describe 'index' do
    def flat_hash(hash, final = [], res = {})
      return res.update(final => hash) unless hash.is_a? Hash
      hash.each { |key, val| flat_hash(val, final + [key], res) }
      res
    end

    let(:settings) { YAML.load_file(File.join(Rails.root, 'config', 'settings.yml')) }
    let(:result_keys) { flat_hash(@json_response).keys.flatten }

    before do
      get :index
      @json_response = JSON.parse(response.body)
    end
    it 'should render a json file with the correct entries' do
      expected = settings[Rails.env].keys

      expect(@json_response.keys.length).to eq expected.length
      expect(@json_response.keys).to match_array(expected)
    end

    it 'should contain all elements in the yaml' do
      expect(result_keys).to_not be_blank
      def recursive_check(hash, yaml)
        yaml.keys.each do |key|
          cur = hash[key]
          cur_yaml = yaml[key]
          expect(cur).to_not be_blank
          expect(cur).to eq cur_yaml
          result_keys.delete(key)
          recursive_check(cur, cur_yaml) if cur_yaml.is_a? Hash
        end
      end
      recursive_check(@json_response, settings[Rails.env])

      # Test if we actually checked every element
      expect(result_keys).to be_blank
    end

    describe 'unwanted variables' do

      it 'should not contain table variables' do
        expect(result_keys).to_not include 'table'
      end

      it 'should not contain modifiable variables' do
        expect(result_keys).to_not include 'modifiable'
      end
    end
  end
end
