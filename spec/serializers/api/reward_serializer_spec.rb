# frozen_string_literal: true

require 'rails_helper'

module Api
  describe RewardSerializer do
    before :each do
      Timecop.freeze(2017, 2, 1)
    end

    let!(:protocol) { FactoryGirl.create(:protocol, :with_rewards) }
    let!(:protocol_subscription) { FactoryGirl.create(:protocol_subscription, protocol: protocol) }
    let!(:responses) do
      FactoryGirl.create(:response, :completed,
                         protocol_subscription: protocol_subscription, open_from: 8.days.ago.in_time_zone)
      FactoryGirl.create(:response, :invite_sent,
                         protocol_subscription: protocol_subscription, open_from: 7.days.ago.in_time_zone)

      # Streak
      (1..6).each do |day|
        FactoryGirl.create(:response, :completed,
                           protocol_subscription: protocol_subscription, open_from: day.days.ago.in_time_zone)
      end
      (0..5).each do |day|
        FactoryGirl.create(:response,
                           protocol_subscription: protocol_subscription, open_from: day.days.from_now.in_time_zone)
      end
    end

    subject(:json) { described_class.new(protocol_subscription).as_json.with_indifferent_access }

    it 'should have the correct initialization' do
      protocol_subscription.reload
      expect(protocol_subscription.responses.length).to eq(6 + 6 + 2)
    end

    describe 'renders the correct json' do
      it 'should contain the correct variables' do
        # Mock the actual calculation
        expect_any_instance_of(Protocol).to receive(:calculate_reward)
          .with(protocol_subscription.protocol_completion)
          .and_return(321)

        # Mock the actual calculation
        expect_any_instance_of(Protocol).to receive(:calculate_reward)
          .with(((1..protocol_subscription.responses.invited.length)))
          .and_return(123)

        expect_any_instance_of(Protocol).to receive(:calculate_reward)
          .with([6])
          .and_return(888)
        json = described_class.new(protocol_subscription).as_json.with_indifferent_access

        expect(json[:person_type]).to eq protocol_subscription.person.type
        expect(json[:protocol_completion]).to eq protocol_subscription.protocol_completion
        expect(json[:earned_euros]).to eq 321
        expect(json[:euro_delta]).to eq 888
        expect(json[:max_still_awardable_euros]).to eq 123
      end

      it 'should contain the correct max_still_awardable_euros' do
        json = described_class.new(protocol_subscription).as_json.with_indifferent_access
        expected = 6 * 500
        expect(json[:max_still_awardable_euros]).to eq expected
      end

      it 'should contain the list of finished questionnaires' do
        expect(json[:protocol_completion]).to be_an Array
        expect(json[:protocol_completion].first).to eq 1
        expect(json[:protocol_completion].second).to eq 0
        (2..7).each do |entry|
          expect(json[:protocol_completion][entry]).to eq entry - 1
        end
        (8..13).each do |entry|
          expected_value = -1
          expect(json[:protocol_completion][entry]).to eq expected_value
        end
      end
    end
  end
end
