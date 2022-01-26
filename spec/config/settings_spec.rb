# frozen_string_literal: true

require 'rails_helper'

describe Rails do
  describe 'settings' do
    let(:settings) { YAML.load_file(File.join(described_class.root, 'config', 'settings.yml')) }

    # rubocop:disable Style/OpenStructUse
    it 'has settings' do
      expect(described_class.application.config.settings).not_to be_blank
      expect(described_class.application.config.settings).to be_a OpenStruct
    end

    it 'has logo settings' do
      expect(described_class.application.config.settings.logo).not_to be_blank
      expect(described_class.application.config.settings.logo).to be_a OpenStruct

      expect(described_class.application.config.settings.logo.mentor_logo).not_to be_blank
      expect(described_class.application.config.settings.logo.mentor_logo)
        .to eq 'logo_mentor.png'

      expect(described_class.application.config.settings.logo.student_logo).not_to be_blank
      expect(described_class.application.config.settings.logo.student_logo)
        .to eq 'logo_student.png'

      expect(described_class.application.config.settings.logo.fallback_logo).not_to be_blank
      expect(described_class.application.config.settings.logo.fallback_logo)
        .to eq 'logo.png'
    end
    # rubocop:enable Style/OpenStructUse

    it 'has application-name settings when the ENV defines this' do
      expect(described_class.application.config.settings.application_name).not_to be_blank
      expect(described_class.application.config.settings.application_name)
        .to eq ENV['PROJECT_NAME']
    end

    it 'merges the settings from the project specific settings' do
      expect(ENV['PROJECT_NAME']).to eq 'demo'
      expect(described_class.application.config.settings.test_setting).not_to be_blank
      expect(described_class.application.config.settings.test_setting)
        .to eq 'test123'
    end
  end
end
