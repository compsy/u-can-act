# frozen_string_literal: true

require 'rails_helper'

describe IdentifierExporter do
  it_should_behave_like 'an object_exporter object'

  describe 'without participants' do
    it 'works without protocol subscriptions' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  describe 'with participants' do
    let(:number_of_students) { 10 }
    let(:number_of_mentors) { 10 }
    let!(:students) do
      FactoryBot.create_list(:student,
                             number_of_students,
                             :with_random_name)
    end

    let!(:mentors) do
      FactoryBot.create_list(:mentor,
                             number_of_mentors,
                             :with_random_name)
    end

    it 'should create a CSV with the correct fields' do
      export = described_class.export_lines.to_a.join.split("\n")
      header = export.first.delete('"').split(';')
      expected = described_class.formatted_fields + described_class.default_fields
      expect(header.length).to eq expected.length
      expect(header).to match_array expected
    end

    it 'should create the correct export' do
      export = described_class.export_lines.to_a.join.split("\n")
      export = export.last(number_of_students + number_of_mentors).map { |entry| entry.delete('"').split(';') }
      export.zip(students + mentors).each do |entry, person|
        expect(entry.first).to eq person.external_identifier
        expect(entry.second).to eq(person.email || '')
        expect(entry.third).to eq person.mobile_phone
      end
    end

    it 'should not export the test accounts' do
      pre_export = described_class.export_lines.to_a.join.split("\n")

      # create a response that should be filtered out
      person = FactoryBot.create(:student, :with_test_phone_number)
      protocol_subscription = FactoryBot.create(:protocol_subscription, person: person)
      FactoryBot.create(:response, protocol_subscription: protocol_subscription)

      post_export = described_class.export_lines.to_a.join.split("\n")
      expect(pre_export).to match_array post_export
      #
      # -1 for the header
      expect(post_export.size - 1).to eq number_of_students + number_of_mentors
    end
  end
end
