# frozen_string_literal: true

require 'rails_helper'

describe Protocol do
  it 'has valid default properties' do
    protocol = FactoryBot.create(:protocol)
    expect(protocol).to be_valid
  end

  describe 'name' do
    it 'does not allow two protocols with the same name' do
      protocolone = FactoryBot.create(:protocol, name: 'myprotocol')
      expect(protocolone).to be_valid
      protocoltwo = FactoryBot.create(:protocol)
      protocoltwo.name = 'myprotocol'
      expect(protocoltwo).not_to be_valid
      expect(protocoltwo.errors.messages).to have_key :name
      expect(protocoltwo.errors.messages[:name]).to include('is al in gebruik')
    end
    it 'does not accept a nil name' do
      protocol = FactoryBot.create(:protocol)
      protocol.name = nil
      expect(protocol).not_to be_valid
      expect(protocol.errors.messages).to have_key :name
      expect(protocol.errors.messages[:name]).to include('moet opgegeven zijn')
    end
    it 'does not accept a blank name' do
      protocol = FactoryBot.create(:protocol)
      protocol.name = ''
      expect(protocol).not_to be_valid
      expect(protocol.errors.messages).to have_key :name
      expect(protocol.errors.messages[:name]).to include('moet opgegeven zijn')
    end
  end

  describe 'duration' do
    it 'is a zero or positive integer' do
      protocol = FactoryBot.create(:protocol)
      protocol.duration = 0
      expect(protocol).to be_valid
      protocol.duration = 1.5
      expect(protocol).not_to be_valid
      protocol.duration = -1
      expect(protocol).not_to be_valid
      expect(protocol.errors.messages).to have_key :duration
      expect(protocol.errors.messages[:duration]).to include('moet groter dan of gelijk zijn aan 0')
    end

    it 'is not nil' do
      protocol = FactoryBot.create(:protocol)
      protocol.duration = nil
      expect(protocol).not_to be_valid
      expect(protocol.errors.messages).to have_key :duration
      expect(protocol.errors.messages[:duration]).to include('is geen getal')
    end
  end

  describe 'stop_measurement' do
    it 'returns the stop_measurement if one is available' do
      protocol = FactoryBot.create(:protocol, :with_measurements)
      stop_measurement = FactoryBot.create(:measurement, :stop_measurement, protocol: protocol)
      protocol.reload
      expect(protocol.stop_measurement).not_to be_nil
      expect(protocol.stop_measurement).to eq(stop_measurement)
    end

    it 'returns nil if no stop_measurement is available' do
      protocol = FactoryBot.create(:protocol, :with_measurements)
      expect(protocol.stop_measurement).to be_nil
    end
  end

  describe 'measurements' do
    it 'destroys the measurements when destroying the protocol' do
      protocol = FactoryBot.create(:protocol, :with_measurements)
      expect(protocol.measurements.first).to be_a(Measurement)
      meascountbefore = Measurement.count
      protocol.destroy
      expect(Measurement.count).to eq(meascountbefore - 1)
    end

    it 'validates the number of stop_measurements' do
      protocol = FactoryBot.create(:protocol, :with_measurements)
      expect(protocol).to be_valid
      FactoryBot.create(:measurement, :stop_measurement, protocol: protocol)
      expect(protocol).to be_valid
      meas = FactoryBot.build(:measurement, :stop_measurement, protocol: protocol)
      meas.save(validate: false)
      expect(protocol).not_to be_valid
    end
  end

  describe 'protocol_subscriptions' do
    it 'destroys the protocol_subscriptions when destroying the protocol' do
      protocol = FactoryBot.create(:protocol, :with_protocol_subscriptions)
      expect(protocol.protocol_subscriptions.first).to be_a(ProtocolSubscription)
      protsubcountbefore = ProtocolSubscription.count
      protocol.destroy
      expect(ProtocolSubscription.count).to eq(protsubcountbefore - 1)
    end
  end

  describe 'push_subscriptions' do
    it 'destroys the push_subscriptions when destroying the protocol' do
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:push_subscription, protocol: protocol)
      expect(protocol.push_subscriptions.first).to be_a(PushSubscription)
      pushsubcountbef = PushSubscription.count
      protocol.destroy
      expect(PushSubscription.count).to eq(pushsubcountbef - 1)
    end
  end

  describe 'informed_consent_questionnaire' do
    it 'is able to set an informed consent questionnaire' do
      questionnaire = FactoryBot.create(:questionnaire)
      protocol = FactoryBot.create(:protocol, informed_consent_questionnaire: questionnaire)
      questionnaire.reload
      expect(questionnaire).to be_valid
      expect(protocol).to be_valid
      expect(protocol.informed_consent_questionnaire).to eq questionnaire
      expect(protocol.informed_consent_questionnaire_id).to eq questionnaire.id
      expect(questionnaire.informed_consent_protocols.count).to eq 1
      expect(questionnaire.informed_consent_protocols.first).to eq protocol
      expect(questionnaire.informed_consent_protocols.first.id).to eq protocol.id
    end
    it 'is able to have multiple protocols with the same informed consent questionnaire' do
      questionnaire = FactoryBot.create(:questionnaire)
      protocols = FactoryBot.create_list(:protocol, 3, informed_consent_questionnaire: questionnaire)
      questionnaire.reload
      expect(questionnaire).to be_valid
      protocols.each do |protocol|
        expect(protocol).to be_valid
        expect(protocol.informed_consent_questionnaire).to eq questionnaire
        expect(protocol.informed_consent_questionnaire_id).to eq questionnaire.id
      end
      expect(questionnaire.informed_consent_protocols.count).to eq 3
      expect(questionnaire.informed_consent_protocols.first).to eq protocols.first
      expect(questionnaire.informed_consent_protocols.first.id).to eq protocols.first.id
    end
    it 'does not have an informed consent questionnaire by default and still be valid' do
      protocol = FactoryBot.create(:protocol)
      expect(protocol).to be_valid
      expect(protocol.informed_consent_questionnaire).to be_nil
      expect(protocol.informed_consent_questionnaire_id).to be_nil
    end
    it 'nullifies the attribute when deleting the informed consent questionnaire' do
      questionnaire = FactoryBot.create(:questionnaire)
      protocol_id = FactoryBot.create(:protocol, informed_consent_questionnaire: questionnaire).id
      protocol = described_class.find_by(id: protocol_id)
      expect(protocol).not_to be_nil
      expect(protocol.informed_consent_questionnaire).to eq questionnaire
      expect(protocol.informed_consent_questionnaire_id).to eq questionnaire.id
      questionnairecountbef = Questionnaire.count
      protocolcountbef = described_class.count
      questionnaire.destroy!
      expect(Questionnaire.count).to eq(questionnairecountbef - 1)
      expect(described_class.count).to eq protocolcountbef
      protocol = described_class.find_by(id: protocol_id)
      expect(protocol).not_to be_nil
      expect(protocol.informed_consent_questionnaire).to be_nil
      expect(protocol.informed_consent_questionnaire_id).to be_nil
    end
    it 'noes longer return the protocol once it has been destroyed' do
      questionnaire = FactoryBot.create(:questionnaire)
      questionnaire_id = questionnaire.id
      protocol = FactoryBot.create(:protocol, informed_consent_questionnaire: questionnaire)
      questionnaire = Questionnaire.find_by(id: questionnaire_id)
      expect(questionnaire).not_to be_nil
      expect(questionnaire.informed_consent_protocols.count).to eq 1
      questionnairecountbef = Questionnaire.count
      protocolcountbef = described_class.count
      protocol.destroy!
      expect(Questionnaire.count).to eq questionnairecountbef
      expect(described_class.count).to eq(protocolcountbef - 1)
      questionnaire = Questionnaire.find_by(id: questionnaire_id)
      expect(questionnaire).not_to be_nil
      expect(questionnaire.informed_consent_protocols.count).to eq 0
    end
  end

  describe 'invitation_text' do
    it 'is possible to define an invitation text' do
      protocol = FactoryBot.create(:protocol)
      protocol.invitation_text = 'test'
      expect { protocol.save! }.not_to raise_error
    end
    it 'has a factory with an invitation text' do
      protocol = FactoryBot.create(:protocol)
      expect(protocol.invitation_text).to be_nil
      protocol = FactoryBot.create(:protocol, :with_invitation_text)
      expect(protocol.invitation_text).not_to be_nil
    end

    it 'is valid without an invitation text' do
      protocol = FactoryBot.create(:protocol)
      expect(protocol.invitation_text).to be_nil
      expect(protocol).to be_valid
    end
  end

  describe 'timestamps' do
    it 'has timestamps for created objects' do
      protocol = FactoryBot.create(:protocol)
      expect(protocol.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(protocol.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'rewards' do
    it 'returns the rewards sorted by threshold' do
      protocol = FactoryBot.create(:protocol)
      reward3 = FactoryBot.create(:reward, protocol: protocol, threshold: 1000, reward_points: 100)
      reward1 = FactoryBot.create(:reward, protocol: protocol, threshold: 94, reward_points: 100)
      reward2 = FactoryBot.create(:reward, protocol: protocol, threshold: 991, reward_points: 100)
      expect(protocol.rewards).to eq([reward1, reward2, reward3])
    end
  end

  describe 'max_streak' do
    it 'returns the reward with the highest threshold' do
      protocol = FactoryBot.create(:protocol)
      reward = FactoryBot.create(:reward, protocol: protocol, threshold: 1000, reward_points: 100)
      FactoryBot.create(:reward, protocol: protocol, threshold: 94, reward_points: 100)
      FactoryBot.create(:reward, protocol: protocol, threshold: 991, reward_points: 100)
      expect(protocol.max_streak).to eq(reward)
    end

    it 'nils if there are no rewards' do
      protocol = FactoryBot.create(:protocol)
      expect(protocol.max_streak).to be_nil
    end
  end

  describe 'find_correct_multiplier' do
    let(:protocol) { FactoryBot.create(:protocol, :with_rewards) }
    let(:protocol_no_rewards) { FactoryBot.create(:protocol) }
    let(:protocol_single_reward) do
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:reward, protocol: protocol, threshold: 10, reward_points: 100)
      protocol
    end

    it 'finds the current applicable multiplier for a given value' do
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:reward, protocol: protocol, threshold: 1000, reward_points: 100)
      FactoryBot.create(:reward, protocol: protocol, threshold: 94, reward_points: 100)
      FactoryBot.create(:reward, protocol: protocol, threshold: 991, reward_points: 100)
      Reward.all.each do |reward|
        expect(protocol.find_correct_multiplier(reward.threshold)).to eq reward.reward_points
      end
    end

    it 'returns 1 if no rewards exist' do
      [1, 10, 13, 100].each do |val|
        expect(protocol_no_rewards.find_correct_multiplier(val)).to eq 1
      end
    end

    it 'works with a single reward' do
      # Pre-threshold
      range = 1...(protocol_single_reward.rewards.first.threshold)
      expected = 1
      range.step(1).each do |value|
        expect(protocol_single_reward.find_correct_multiplier(value)).to eq expected
      end

      # Post-threshold
      range = protocol_single_reward.rewards.first.threshold...(protocol_single_reward.rewards.first.threshold * 10)
      expected = protocol_single_reward.rewards.first.reward_points
      range.step(1).each do |value|
        expect(protocol_single_reward.find_correct_multiplier(value)).to eq expected
      end
    end

    it 'returns the reward of which a value just exceeded the threshold' do
      rewards_hash = {}
      protocol.rewards.each { |rw| rewards_hash[rw.threshold] = rw.reward_points }
      max_rw_threshold = rewards_hash.keys.max
      result = (1..(max_rw_threshold + 1)).step(1).map do |val|
        protocol.find_correct_multiplier(val)
      end
      rewards_hash[1]
      expect(result).to eq [
        rewards_hash[1],
        rewards_hash[1],
        rewards_hash[1],
        rewards_hash[1],
        rewards_hash[5],
        rewards_hash[5],
        rewards_hash[7],
        rewards_hash[7]
      ]
    end
  end

  describe 'calculate_reward' do
    let(:protocol) { FactoryBot.create(:protocol, :with_rewards) }
    let(:protocol_no_rewards) { FactoryBot.create(:protocol) }
    let(:protocol_single_reward) do
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:reward, protocol: protocol, threshold: 1, reward_points: 100)
      protocol
    end

    let(:measurement_completion) do
      [{ streak: 1, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 2, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 3, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 0, periodical: true, reward_points: 1, future: false, completed: false },
       { streak: 0, periodical: true, reward_points: 1, future: false, completed: false },
       { streak: 1, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 0, periodical: true, reward_points: 1, future: false, completed: false },
       { streak: 1, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 2, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 3, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 4, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 5, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 6, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 7, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 8, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 9, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 10, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 0, periodical: true, reward_points: 1, future: false, completed: false },
       { streak: 0, periodical: true, reward_points: 1, future: false, completed: false },
       { streak: 1, periodical: true, reward_points: 1, future: false, completed: true },
       { streak: 2, periodical: true, reward_points: 1, future: true, completed: false },
       { streak: 3, periodical: true, reward_points: 1, future: true, completed: false }]
    end

    it 'calculates the correct reward when there are no measurements' do
      measurement_completion = [{ future: true }] * 10
      expected_value = 0
      result = protocol.calculate_reward(measurement_completion)
      expect(result).to eq expected_value
    end

    it 'calculates the default multiplier of 1 if no multipliers are available' do
      expected_value = measurement_completion.reduce(0) { |tot, val| tot + (val[:completed] ? val[:reward_points] : 0) }
      result = protocol_no_rewards.calculate_reward(measurement_completion)
      expect(result).to eq expected_value
    end

    it 'calculates the correct reward when there is a single reward' do
      expected_value = measurement_completion.filter_map { |entry| entry[:reward_points] if entry[:completed] }.sum
      expected_value *= 100

      result = protocol_single_reward.calculate_reward(measurement_completion)
      expect(result).to eq expected_value
    end

    it 'calculates the correct reward when there are multilple rewards' do
      expected_value = (1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 3 + 3 + 5 + 5 + 5 + 5 + 1) * 100
      result = protocol.calculate_reward(measurement_completion)
      expect(result).to eq expected_value
    end

    it 'caluclates the correct reward for a subset of items' do
      current_measurement_completion = measurement_completion[4..8]
      expected = current_measurement_completion.reduce(0) do |tot, val|
        tot + (val[:streak] > 0 ? 1 * val[:reward_points] : 0) * 100
      end
      result = protocol.calculate_reward(current_measurement_completion, false)
      expect(result).to eq expected
    end

    it 'calculates the max possible future score when the flag check_future is set' do
      current_measurement_completion = measurement_completion[-2..]
      expected = current_measurement_completion.reduce(0) do |tot, val|
        tot + (val[:streak] > 0 ? 1 * val[:reward_points] : 0) * 100
      end
      result = protocol.calculate_reward(current_measurement_completion, true)
      expect(result).to eq expected
    end

    it 'does not calculate the max possible future score when the flag check_future is not set' do
      current_measurement_completion = measurement_completion[-2..]
      result = protocol.calculate_reward(current_measurement_completion, false)
      expect(result).to eq 0
    end
  end
end
