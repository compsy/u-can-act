# frozen_string_literal: true

require 'rails_helper'

describe Protocol do
  it 'should have valid default properties' do
    protocol = FactoryGirl.build(:protocol)
    expect(protocol.valid?).to be_truthy
  end

  describe 'name' do
    it 'should not allow two protocols with the same name' do
      protocolone = FactoryGirl.create(:protocol, name: 'myprotocol')
      expect(protocolone.valid?).to be_truthy
      protocoltwo = FactoryGirl.build(:protocol, name: 'myprotocol')
      expect(protocoltwo.valid?).to be_falsey
      expect(protocoltwo.errors.messages).to have_key :name
      expect(protocoltwo.errors.messages[:name]).to include('is al in gebruik')
    end
    it 'should not accept a nil name' do
      protocol = FactoryGirl.build(:protocol, name: nil)
      expect(protocol.valid?).to be_falsey
      expect(protocol.errors.messages).to have_key :name
      expect(protocol.errors.messages[:name]).to include('moet opgegeven zijn')
    end
    it 'should not accept a blank name' do
      protocol = FactoryGirl.build(:protocol, name: '')
      expect(protocol.valid?).to be_falsey
      expect(protocol.errors.messages).to have_key :name
      expect(protocol.errors.messages[:name]).to include('moet opgegeven zijn')
    end
  end

  describe 'duration' do
    it 'should be a zero or positive integer' do
      protocol = FactoryGirl.build(:protocol)
      protocol.duration = 0
      expect(protocol.valid?).to be_truthy
      protocol.duration = -1
      expect(protocol.valid?).to be_falsey
      expect(protocol.errors.messages).to have_key :duration
      expect(protocol.errors.messages[:duration]).to include('moet groter dan of gelijk zijn aan 0')
    end
    it 'should not be nil' do
      protocol = FactoryGirl.build(:protocol, duration: nil)
      expect(protocol.valid?).to be_falsey
      expect(protocol.errors.messages).to have_key :duration
      expect(protocol.errors.messages[:duration]).to include('is geen getal')
    end
  end

  describe 'measurements' do
    it 'should destroy the measurements when destroying the protocol' do
      protocol = FactoryGirl.create(:protocol, :with_measurements)
      expect(protocol.measurements.first).to be_a(Measurement)
      meascountbefore = Measurement.count
      protocol.destroy
      expect(Measurement.count).to eq(meascountbefore - 1)
    end
  end

  describe 'protocol_subscriptions' do
    it 'should destroy the protocol_subscriptions when destroying the protocol' do
      protocol = FactoryGirl.create(:protocol, :with_protocol_subscriptions)
      expect(protocol.protocol_subscriptions.first).to be_a(ProtocolSubscription)
      protsubcountbefore = ProtocolSubscription.count
      protocol.destroy
      expect(ProtocolSubscription.count).to eq(protsubcountbefore - 1)
    end
  end

  describe 'informed_consent_questionnaire' do
    it 'should be able to set an informed consent questionnaire' do
      questionnaire = FactoryGirl.create(:questionnaire)
      protocol = FactoryGirl.create(:protocol, informed_consent_questionnaire: questionnaire)
      questionnaire.reload
      expect(questionnaire.valid?).to be_truthy
      expect(protocol.valid?).to be_truthy
      expect(protocol.informed_consent_questionnaire).to eq questionnaire
      expect(protocol.informed_consent_questionnaire_id).to eq questionnaire.id
      expect(questionnaire.informed_consent_protocols.count).to eq 1
      expect(questionnaire.informed_consent_protocols.first).to eq protocol
      expect(questionnaire.informed_consent_protocols.first.id).to eq protocol.id
    end
    it 'should be able to have multiple protocols with the same informed consent questionnaire' do
      questionnaire = FactoryGirl.create(:questionnaire)
      protocols = FactoryGirl.create_list(:protocol, 3, informed_consent_questionnaire: questionnaire)
      questionnaire.reload
      expect(questionnaire.valid?).to be_truthy
      protocols.each do |protocol|
        expect(protocol.valid?).to be_truthy
        expect(protocol.informed_consent_questionnaire).to eq questionnaire
        expect(protocol.informed_consent_questionnaire_id).to eq questionnaire.id
      end
      expect(questionnaire.informed_consent_protocols.count).to eq 3
      expect(questionnaire.informed_consent_protocols.first).to eq protocols.first
      expect(questionnaire.informed_consent_protocols.first.id).to eq protocols.first.id
    end
    it 'should not have an informed consent questionnaire by default and still be valid' do
      protocol = FactoryGirl.create(:protocol)
      expect(protocol.valid?).to be_truthy
      expect(protocol.informed_consent_questionnaire).to be_nil
      expect(protocol.informed_consent_questionnaire_id).to be_nil
    end
    it 'should nullify the attribute when deleting the informed consent questionnaire' do
      questionnaire = FactoryGirl.create(:questionnaire)
      protocol_id = FactoryGirl.create(:protocol, informed_consent_questionnaire: questionnaire).id
      protocol = Protocol.find_by_id(protocol_id)
      expect(protocol).not_to be_nil
      expect(protocol.informed_consent_questionnaire).to eq questionnaire
      expect(protocol.informed_consent_questionnaire_id).to eq questionnaire.id
      questionnairecountbef = Questionnaire.count
      protocolcountbef = Protocol.count
      questionnaire.destroy!
      expect(Questionnaire.count).to eq(questionnairecountbef - 1)
      expect(Protocol.count).to eq protocolcountbef
      protocol = Protocol.find_by_id(protocol_id)
      expect(protocol).not_to be_nil
      expect(protocol.informed_consent_questionnaire).to be_nil
      expect(protocol.informed_consent_questionnaire_id).to be_nil
    end
    it 'should no longer return the protocol once it has been destroyed' do
      questionnaire = FactoryGirl.create(:questionnaire)
      questionnaire_id = questionnaire.id
      protocol = FactoryGirl.create(:protocol, informed_consent_questionnaire: questionnaire)
      questionnaire = Questionnaire.find_by_id(questionnaire_id)
      expect(questionnaire).not_to be_nil
      expect(questionnaire.informed_consent_protocols.count).to eq 1
      questionnairecountbef = Questionnaire.count
      protocolcountbef = Protocol.count
      protocol.destroy!
      expect(Questionnaire.count).to eq questionnairecountbef
      expect(Protocol.count).to eq(protocolcountbef - 1)
      questionnaire = Questionnaire.find_by_id(questionnaire_id)
      expect(questionnaire).not_to be_nil
      expect(questionnaire.informed_consent_protocols.count).to eq 0
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      protocol = FactoryGirl.create(:protocol)
      expect(protocol.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(protocol.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'rewards' do
    it 'should return the rewards sorted by threshold' do
      protocol = FactoryGirl.create(:protocol)
      reward3 = FactoryGirl.create(:reward, protocol: protocol, threshold: 1000, reward_points: 100)
      reward1 = FactoryGirl.create(:reward, protocol: protocol, threshold: 94, reward_points: 100)
      reward2 = FactoryGirl.create(:reward, protocol: protocol, threshold: 991, reward_points: 100)
      expect(protocol.rewards).to eq([reward1, reward2, reward3])
    end
  end

  describe 'find_correct_multiplier' do
    let(:protocol) { FactoryGirl.create(:protocol, :with_rewards) }
    let(:protocol_no_rewards) { FactoryGirl.create(:protocol) }
    let(:protocol_single_reward) do
      reward = FactoryGirl.create(:reward, threshold: 1, reward_points: 100)
      FactoryGirl.create(:protocol, rewards: [reward])
    end

    it 'should find the current applicable multiplier for a given value' do
      Reward.all.each do |reward|
        expect(protocol.find_correct_multiplier(reward.threshold)).to eq reward.reward_points
      end
    end

    it 'should return 1 if no rewards exist' do
      [1, 10, 13, 100].each do |val|
        expect(protocol_no_rewards.find_correct_multiplier(val)).to eq 1
      end
    end

    it 'should return the reward of which a value just exceeded the threshold' do
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
    let(:protocol) { FactoryGirl.create(:protocol, :with_rewards) }
    let(:protocol_no_rewards) { FactoryGirl.create(:protocol) }
    let(:protocol_single_reward) do
      protocol = FactoryGirl.create(:protocol)
      FactoryGirl.create(:reward, protocol: protocol, threshold: 1, reward_points: 100)
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

    it 'should calculate the correct reward when there are no measurements' do
      measurement_completion = [{ future: true }] * 10
      expected_value = 0
      result = protocol.calculate_reward(measurement_completion)
      expect(result).to eq expected_value
    end

    it 'should calculate the correct reward when there are no rewards' do
      expected_value = 0
      result = protocol_no_rewards.calculate_reward(measurement_completion)
      expect(result).to eq expected_value
    end

    it 'should calculate the correct reward when there is a single reward' do
      expected_value = measurement_completion.map { |entry| entry[:reward_points] if entry[:completed] }.compact.sum
      expected_value *= 100

      result = protocol_single_reward.calculate_reward(measurement_completion)
      expect(result).to eq expected_value
    end

    it 'should calculate the correct reward when there are multilple rewards' do
      expected_value = (1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 3 + 3 + 5 + 5 + 5 + 5 + 1) * 100
      result = protocol.calculate_reward(measurement_completion)
      expect(result).to eq expected_value
    end

    it 'should caluclate the correct reward for a subset of items' do
      current_measurement_completion = measurement_completion[4..8]
      expected = current_measurement_completion.reduce(0) do |tot, val|
        tot + (val[:streak] > 0 ? 1 * val[:reward_points] : 0) * 100
      end
      result = protocol.calculate_reward(current_measurement_completion, false)
      expect(result).to eq expected
    end

    it 'should calculate the max possible future score, then the flag chcek_future is set' do
      current_measurement_completion = measurement_completion[-1..-2]
      expected = current_measurement_completion.reduce(0) do |tot, val|
        tot + (val[:streak] > 0 ? 1 * val[:reward_points] : 0) * 100
      end
      result = protocol.calculate_reward(current_measurement_completion, true)
      expect(result).to eq expected
    end

    it 'should not calculate the max possible future score, then the flag chcek_future is not set' do
      current_measurement_completion = measurement_completion[-1..-2]
      result = protocol.calculate_reward(current_measurement_completion, false)
      expect(result).to eq 0
    end
  end
end
