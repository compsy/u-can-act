# frozen_string_literal: true

require 'rails_helper'

describe RewardExporter do
  it_behaves_like 'an object_exporter object'

  describe 'without participants' do
    it 'works without protocol subscriptions' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  describe 'with participants' do
    let(:number_of_students) { 10 }
    let!(:students) do
      FactoryBot.create_list(:student,
                             number_of_students,
                             :with_random_name,
                             :with_protocol_subscriptions, :with_iban)
    end

    before do
      FactoryBot.create(:mentor, :with_protocol_subscriptions)
    end

    it 'creates a CSV with the correct fields' do
      export = described_class.export_lines.to_a.join.split("\n")
      header = export.first.delete('"').split(';')
      expected = described_class.formatted_fields + described_class.default_fields
      expect(header.length).to eq expected.length
      expect(header).to match_array expected
    end

    it 'exports only the students' do
      export = described_class.export_lines.to_a.join.split("\n")
      # -1 for the header
      expect(export.size - 1).to eq number_of_students
    end

    it 'creates the correct export' do
      reward = 0
      students.each do |student|
        expect(CalculateEarnedEurosByPerson)
          .to receive(:run!)
          .with(person: student)
          .and_return reward
        reward += 10
      end
      export = described_class.export_lines.to_a.join.split("\n")
      export = export.last(number_of_students).map { |entry| entry.delete('"').split(';') }
      reward = 0
      export.zip(students).each do |entry, student|
        expect(entry[0]).to eq reward.to_s
        expect(entry[1]).to eq student.external_identifier
        expect(entry[2]).to eq student.first_name
        expect(entry[3]).to eq student.last_name
        expect(entry[4]).to eq student.iban
        expect(entry[5]).to eq student.mobile_phone
        expect(entry[6]).to eq student.email
        reward += 10
      end
    end

    it 'does not export the test accounts' do
      pre_export = described_class.export_lines.to_a.join.split("\n")

      # create a response that should be filtered out
      person = FactoryBot.create(:student, :with_test_phone_number)
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create(:response, protocol_subscription: protocol_subscription)

      post_export = described_class.export_lines.to_a.join.split("\n")
      expect(pre_export).to match_array post_export
      #
      # -1 for the header
      expect(post_export.size - 1).to eq number_of_students
    end
  end
end
