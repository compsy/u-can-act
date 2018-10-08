# frozen_string_literal: true

require 'rails_helper'

describe Rails do
  describe 'settings' do
    let(:settings) { YAML.load_file(File.join(Rails.root, 'config', 'settings.yml')) }
    it 'should have settings' do
      expect(Rails.application.config.settings).to_not be_blank
      expect(Rails.application.config.settings).to be_a OpenStruct
    end

    it 'should have logo settings' do
      expect(Rails.application.config.settings.logo).to_not be_blank
      expect(Rails.application.config.settings.logo).to be_a OpenStruct

      expect(Rails.application.config.settings.logo.mentor_logo).to_not be_blank
      expect(Rails.application.config.settings.logo.mentor_logo)
        .to eq settings[Rails.env]['logo']['mentor_logo']

      expect(Rails.application.config.settings.logo.student_logo).to_not be_blank
      expect(Rails.application.config.settings.logo.student_logo)
        .to eq settings[Rails.env]['logo']['student_logo']

      expect(Rails.application.config.settings.logo.fallback_logo).to_not be_blank
      expect(Rails.application.config.settings.logo.fallback_logo)
        .to eq settings[Rails.env]['logo']['fallback_logo']
    end

    it 'should have application-name settings' do
      expect(Rails.application.config.settings.application_name).to_not be_blank
      expect(Rails.application.config.settings.application_name)
        .to eq settings[Rails.env]['application_name']
    end
  end
end
