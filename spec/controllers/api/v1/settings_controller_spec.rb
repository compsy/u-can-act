# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SettingsController, type: :controller do
  describe 'index' do
    def flat_hash(hash, final = [], res = {})
      return res.update(final => hash) unless hash.is_a? Hash

      hash.each { |key, val| flat_hash(val, final + [key], res) }
      res
    end

    let(:settings) { YAML.load_file(Rails.root.join('config/settings.yml')) }
    let(:specific_settings) do
      YAML.load_file(Rails.root.join('projects', ENV.fetch('PROJECT_NAME', nil), 'config', 'settings.yml'))
    end

    let(:current_settings) { settings[Rails.env].deep_merge(specific_settings[Rails.env]) }
    let(:result_keys) { flat_hash(@json_response).keys.flatten }

    before do
      get :index
      @json_response = JSON.parse(response.body)
    end

    it 'renders a json file with the correct entries' do
      expected = current_settings.keys

      expect(@json_response.keys.length).to eq expected.length
      expect(@json_response.keys).to match_array(expected)
    end

    it 'contains all elements in the yaml' do
      expect(result_keys).not_to be_blank
      def recursive_check(hash, yaml)
        optional_settings = %w[company_logo]
        yaml.keys.each do |key|
          cur = hash[key]
          cur_yaml = yaml[key]
          if cur_yaml.is_a?(String)
            cur_yaml.gsub!("<%=ENV['PROJECT_NAME']%>", ENV.fetch('PROJECT_NAME', nil))
            cur_yaml.gsub!("<%=ENV['SITE_LOCATION']%>", ENV.fetch('SITE_LOCATION', nil))
          end
          # Company logo is an optional setting
          expect(cur).not_to be_nil unless optional_settings.include?(key)
          expect(cur).to eq cur_yaml unless cur_yaml.is_a?(Hash) # We don't care about the intermediate nodes
          result_keys.delete(key)
          recursive_check(cur, cur_yaml) if cur_yaml.is_a? Hash
        end
      end
      recursive_check(@json_response, current_settings)

      # Test if we actually checked every element
      expect(result_keys).to be_blank
    end

    describe 'unwanted variables' do
      it 'does not contain table variables' do
        expect(result_keys).not_to include 'table'
      end

      it 'does not contain modifiable variables' do
        expect(result_keys).not_to include 'modifiable'
      end
    end
  end
end
