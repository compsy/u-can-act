# frozen_string_literal: true

require 'rails_helper'

describe ProtocolTransferExporter do
  it_should_behave_like 'an object_exporter object'

  context 'without protocol transfers' do
    it 'works without protocol transfers' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  context 'with protocol transfers' do
    before do
      student = FactoryBot.create(:student)
      mentor = FactoryBot.create(:mentor)
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
      mentor2 = FactoryBot.create(:mentor, email: 'mentor2@mentor.com')
      protocol_subscription.transfer!(mentor2)
    end

    it 'works with protocol transfers' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 2
      # bubblebabble format for first field (person_id)
      expect(export.last.split(';', -1).second).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
    end
    it 'filters out some numbers' do
      old_env = ENV['TEST_PHONE_NUMBERS']
      ENV['TEST_PHONE_NUMBERS'] = '0653415423,0621312311'

      student = FactoryBot.create(:student)
      mentor = FactoryBot.create(:mentor, email: 'mentor3@mentor.com')
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)

      mentor2 = FactoryBot.create(:mentor,
                                  email: 'mentor4@mentor.com',
                                  mobile_phone: ENV['TEST_PHONE_NUMBERS'].split(',').first)
      protocol_subscription.transfer!(mentor2)
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 2
      # bubblebabble format for first field (person_id)
      expect(export.last.split(';', -1).second).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
      ENV['TEST_PHONE_NUMBERS'] = old_env
    end
  end
end
