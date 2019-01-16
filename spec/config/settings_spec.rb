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
        .to eq 'logo_mentor.png'

      expect(Rails.application.config.settings.logo.student_logo).to_not be_blank
      expect(Rails.application.config.settings.logo.student_logo)
        .to eq 'logo_student.png'

      expect(Rails.application.config.settings.logo.fallback_logo).to_not be_blank
      expect(Rails.application.config.settings.logo.fallback_logo)
        .to eq 'logo.png'
    end

    it 'should have application-name settings when the ENV defines this' do
      expect(Rails.application.config.settings.application_name).to_not be_blank
      expect(Rails.application.config.settings.application_name)
        .to eq ENV['PROJECT_NAME']
    end

    it 'should merge the settings from the project specific settings' do
      expect(ENV['PROJECT_NAME']).to eq 'demo'
      expect(Rails.application.config.settings.test_setting).to_not be_blank
      expect(Rails.application.config.settings.test_setting)
        .to eq 'test123'
    end
  end
end
