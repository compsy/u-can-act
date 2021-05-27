# frozen_string_literal: true

require 'rails_helper'

describe ProofOfParticipationExporter do
  it_behaves_like 'an object_exporter object'

  describe 'without participants' do
    it 'works without protocol subscriptions' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  describe 'with participants' do
    let(:number_of_students) { 10 }
    let(:number_of_mentors) { 1 }
    let!(:students) do
      FactoryBot.create_list(:student, number_of_students,
                             :with_random_name,
                             :with_protocol_subscriptions,
                             :with_iban)
    end
    let!(:mentors) { FactoryBot.create_list(:mentor, number_of_mentors, :with_protocol_subscriptions) }

    it 'creates a CSV with the correct fields' do
      export = described_class.export_lines.to_a.join.split("\n")
      header = export.first.delete('"').split(';')
      expected = described_class.formatted_fields + described_class.default_fields
      expect(header.length).to eq expected.length
      expect(header).to match_array expected
    end

    it 'exports the students and mentors' do
      export = described_class.export_lines.to_a.join.split("\n")
      # -1 for the header
      # Note that it should not export the mentors
      expect(export.size - 1).to eq number_of_students # + number_of_mentors
      expect(export.size - 1).to eq ProtocolSubscription.count - number_of_mentors
    end

    it 'creates the correct export' do
      completed = 2
      ProtocolSubscription.all.each do |protocol_subscription|
        (1..completed).map do |day|
          FactoryBot.create(:response,
                            :completed,
                            protocol_subscription: protocol_subscription,
                            open_from: day.days.ago.in_time_zone)
        end
        FactoryBot.create(:response,
                          protocol_subscription: protocol_subscription,
                          open_from: 1.day.ago.in_time_zone)
        FactoryBot.create(:response,
                          protocol_subscription: protocol_subscription,
                          open_from: 1.day.from_now.in_time_zone)
        completed += 1
      end
      export = described_class.export_lines.to_a.join.split("\n")
      export = export.last(ProtocolSubscription.count - number_of_mentors).map { |entry| entry.delete('"').split(';') }
      completed = 2
      prot_subs = ProtocolSubscription.all.reject { |prot_sub| prot_sub.person.mentor? }
      export.zip(prot_subs).each do |entry, subscription|
        expect(entry[1]).to eq subscription.person.first_name
        expect(entry[2]).to eq subscription.person.last_name
        expect(entry[5]).to eq completed.to_s
        expect(entry[8]).to eq subscription.state
        completed += 1
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

      # -1 for the header
      # Note that it should not export the mentors
      expect(post_export.size - 1).to eq number_of_students # + number_of_mentors
      expect(post_export.size - 1).to eq ProtocolSubscription.count - 1 - number_of_mentors
    end
  end
end
