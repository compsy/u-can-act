# frozen_string_literal: true

require 'rails_helper'

describe ProtocolTransferExporter do
  it_behaves_like 'an object_exporter object'

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

      # External ids
      ids = Person.pluck(:external_identifier)
      id_col = export.last.split(';', -1).second
      expect(ids).to(be_any { |id| id_col.include? id })
      expect(id_col).to match(/\A"[a-z0-9]{4}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
    end

    it 'filters out some numbers' do
      old_env = ENV.fetch('TEST_PHONE_NUMBERS', nil)
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

      # External ids
      ids = Person.all.map { |p| p.external_identifier unless Exporters.test_phone_number? p.mobile_phone }
      id_col = export.last.split(';', -1).second
      expect(ids).to(be_any { |id| id_col.include? id })
      expect(id_col).to match(/\A"[a-z0-9]{4}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
      ENV['TEST_PHONE_NUMBERS'] = old_env
    end
  end
end
