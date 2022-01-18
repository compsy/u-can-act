# frozen_string_literal: true

require 'rails_helper'

describe ProtocolSubscription do
  it 'has valid default properties' do
    protocol_subscription = FactoryBot.create(:protocol_subscription)
    expect(protocol_subscription).to be_valid
  end

  context 'scopes' do
    describe 'active' do
      it 'returns protocol_subscriptions that were not completed' do
        actives = FactoryBot.create_list(:protocol_subscription, 10, state: ProtocolSubscription::ACTIVE_STATE)
        FactoryBot.create_list(:protocol_subscription, 15, state: ProtocolSubscription::CANCELED_STATE)
        FactoryBot.create_list(:protocol_subscription, 20, state: ProtocolSubscription::COMPLETED_STATE)
        expect(described_class.active.count).to eq 10
        expect(described_class.active).to eq actives
      end
    end
  end

  describe 'person_id' do
    it 'has one' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.person_id = nil
      expect(protocol_subscription).not_to be_valid
      expect(protocol_subscription.errors.messages).to have_key :person
      expect(protocol_subscription.errors.messages[:person]).to include('moet bestaan')
    end
    it 'works to retrieve a Person' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.person).to be_a(Person)
    end
  end

  describe 'filling_out_for_id' do
    it 'has one' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.filling_out_for_id = nil
      expect(protocol_subscription).not_to be_valid
      expect(protocol_subscription.errors.messages).to have_key :filling_out_for
      expect(protocol_subscription.errors.messages[:filling_out_for]).to include('moet bestaan')
    end
    it 'works to retrieve a Person' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.filling_out_for).to be_a(Person)
    end
    it 'sets the provided person by default as a filling_out_for_person' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.filling_out_for).to eq protocol_subscription.person
    end
  end

  describe 'end_date' do
    it 'has one' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.end_date = nil
      expect(protocol_subscription).not_to be_valid
      expect(protocol_subscription.errors.messages).to have_key :end_date
      expect(protocol_subscription.errors.messages[:end_date]).to include('moet opgegeven zijn')
    end
    it 'works to retrieve a Time object' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.end_date).to be_a(Time)
    end
    it 'calculates the default end_date if none is provided' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.end_date).to(
        eq(TimeTools.increase_by_duration(protocol_subscription.start_date,
                                          protocol_subscription.protocol.duration))
      )
    end
    it 'does not overwrite a given end_date' do
      end_date = TimeTools.increase_by_duration(Time.new(2017, 4, 10, 0, 0, 0).in_time_zone, 3.days)
      protocol_subscription = FactoryBot.create(:protocol_subscription, end_date: end_date)
      expect(protocol_subscription.end_date).to eq end_date
    end
  end

  describe 'protocol_id' do
    it 'has one' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.protocol_id = nil
      expect(protocol_subscription).not_to be_valid
      expect(protocol_subscription.errors.messages).to have_key :protocol
      expect(protocol_subscription.errors.messages[:protocol]).to include('moet bestaan')
    end
    it 'works to retrieve a Protocol' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.protocol).to be_a(Protocol)
    end
  end

  describe 'validates uniqueness of students per mentor' do
    let(:mentor) { FactoryBot.create(:mentor) }
    let(:student) { FactoryBot.create(:student) }

    # Commented this to allow to start multiple mentor'ed diary studies for the SDV project.
    # it 'does not allow two protocol subscriptions with the same filling_out_for_id' do
    # prot1 = FactoryBot.create(:protocol_subscription, state: described_class::ACTIVE_STATE,
    # person: mentor,
    # filling_out_for: student)
    # prot2 = FactoryBot.create(:protocol_subscription, state: described_class::ACTIVE_STATE,
    # person: prot1.person)
    # prot2.filling_out_for_id = prot1.filling_out_for_id
    # expect(prot2).not_to be_valid
    # expect(prot2.errors.messages).to have_key :filling_out_for
    # expect(prot2.errors.messages[:filling_out_for]).to include('is al in gebruik')
    # expect { prot2.save! }.to raise_error(ActiveRecord::RecordInvalid,
    # 'Validatie mislukt: Filling out for is al in gebruik')
    # end
    #

    it 'allows two subscriptions with the same filling_out_for_id and different states if one is completed' do
      prot1 = FactoryBot.create(:protocol_subscription, state: described_class::COMPLETED_STATE,
                                                        person: mentor,
                                                        filling_out_for: student)
      prot2 = FactoryBot.create(:protocol_subscription, state: described_class::ACTIVE_STATE,
                                                        person: prot1.person,
                                                        filling_out_for_id: prot1.filling_out_for_id)
      expect(prot2).to be_valid
      expect { prot2.save! }.not_to raise_error
    end
    it 'allows two subscriptions with the same filling_out_for_id and different states if one is still active' do
      prot1 = FactoryBot.create(:protocol_subscription, state: described_class::ACTIVE_STATE,
                                                        person: mentor,
                                                        filling_out_for: student)
      prot2 = FactoryBot.create(:protocol_subscription, state: described_class::COMPLETED_STATE,
                                                        person: prot1.person,
                                                        filling_out_for_id: prot1.filling_out_for_id)
      expect(prot2).to be_valid
      expect { prot2.save! }.not_to raise_error
    end
    it 'allows two protocol subscriptions with the same state as long as they are not active' do
      states = [described_class::CANCELED_STATE, described_class::COMPLETED_STATE]
      states.each do |state|
        prot1 = FactoryBot.create(:protocol_subscription, state: state, person: mentor, filling_out_for: student)
        prot2 = FactoryBot.create(:protocol_subscription, state: state,
                                                          person: prot1.person,
                                                          filling_out_for_id: prot1.filling_out_for_id)
        expect(prot2).to be_valid
        expect { prot2.save! }.not_to raise_error
      end
    end
    it 'allows a student filling out for him/herself to have two active subscriptions' do
      prot1 = FactoryBot.create(:protocol_subscription, state: described_class::ACTIVE_STATE)
      prot2 = FactoryBot.create(:protocol_subscription, state: described_class::ACTIVE_STATE,
                                                        person: prot1.person,
                                                        filling_out_for_id: prot1.filling_out_for_id)
      expect(prot2).to be_valid
      expect { prot2.save! }.not_to raise_error
    end
  end

  describe 'state' do
    it 'is one of the predefined states' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.state = ProtocolSubscription::ACTIVE_STATE
      expect(protocol_subscription).to be_valid
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.state = ProtocolSubscription::CANCELED_STATE
      expect(protocol_subscription).to be_valid
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.state = ProtocolSubscription::COMPLETED_STATE
      expect(protocol_subscription).to be_valid
    end
    it 'is not nil' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.state = nil
      expect(protocol_subscription).not_to be_valid
      expect(protocol_subscription.errors.messages).to have_key :state
      expect(protocol_subscription.errors.messages[:state]).to include('is niet in de lijst opgenomen')
    end
    it 'is not empty' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.state = ''
      expect(protocol_subscription).not_to be_valid
      expect(protocol_subscription.errors.messages).to have_key :state
      expect(protocol_subscription.errors.messages[:state]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.state = 'somestring'
      expect(protocol_subscription).not_to be_valid
      expect(protocol_subscription.errors.messages).to have_key :state
      expect(protocol_subscription.errors.messages[:state]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'transfer!' do
    let!(:original_mentor) { FactoryBot.create(:mentor, email: 'mentor1@gmail.com') }
    let!(:new_mentor) { FactoryBot.create(:mentor, email: 'mentor2@gmail.com') }
    let!(:protocol_subscription) { FactoryBot.create(:protocol_subscription, person: original_mentor) }

    it 'creates a new protocol transfer object with the correct properties' do
      expect(protocol_subscription.protocol_transfers).to be_blank
      protocol_subscription.transfer!(new_mentor)
      expect(protocol_subscription.protocol_transfers).not_to be_blank
      expect(protocol_subscription.protocol_transfers.length).to eq 1
      transfer = protocol_subscription.protocol_transfers.first

      expect(transfer.from).to eq original_mentor
      expect(transfer.to).to eq new_mentor
      expect(transfer.protocol_subscription).to eq protocol_subscription
    end

    it 'transfers the protocol subscription to the provided transfer_to person' do
      expect(protocol_subscription.person).to eq original_mentor
      protocol_subscription.transfer!(new_mentor)
      protocol_subscription.reload
      expect(protocol_subscription.person).not_to eq original_mentor
      expect(protocol_subscription.person).to eq new_mentor
    end

    it 'raises if the person transfered to is the same as the original person' do
      expect(protocol_subscription.person).to eq original_mentor
      expect { protocol_subscription.transfer!(original_mentor) }
        .to raise_error(RuntimeError,
                        'The person you transfer to should not be the same as the original person!')
      protocol_subscription.reload
      expect(protocol_subscription.person).to eq original_mentor
    end

    it 'also changes the filling_out_for if this is the same as the person' do
      protocol_subscription.filling_out_for = original_mentor
      expect(protocol_subscription.person).to eq protocol_subscription.filling_out_for

      protocol_subscription.transfer!(new_mentor)
      protocol_subscription.reload
      expect(protocol_subscription.person).not_to eq original_mentor
      expect(protocol_subscription.filling_out_for).not_to eq original_mentor
      expect(protocol_subscription.person).to eq new_mentor
      expect(protocol_subscription.filling_out_for).to eq new_mentor
    end
  end

  describe 'active?' do
    it 'is active when the state is active' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, state: described_class::ACTIVE_STATE)
      expect(protocol_subscription).to be_active
    end
    it 'is active when the state is not active' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, state: described_class::CANCELED_STATE)
      expect(protocol_subscription).not_to be_active
      protocol_subscription.state = described_class::COMPLETED_STATE
      protocol_subscription.save!
      expect(protocol_subscription).not_to be_active
    end
  end

  describe 'cancel!' do
    before do
      @old_value = Delayed::Worker.delay_jobs
      Delayed::Worker.delay_jobs = false
    end

    after do
      Delayed::Worker.delay_jobs = @old_value
    end

    it 'cancels the protocol subscription' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, state: described_class::ACTIVE_STATE)
      protocol_subscription.cancel!
      expect(protocol_subscription.state).to eq described_class::CANCELED_STATE
      expect(protocol_subscription.end_date).to be_within(1.minute).of(Time.zone.now)
    end
    it 'destroys future responses' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, state: described_class::ACTIVE_STATE)
      FactoryBot.create_list(:response, 3, protocol_subscription: protocol_subscription)
      FactoryBot.create_list(:response, 5, :completed, protocol_subscription: protocol_subscription)
      FactoryBot.create_list(:response, 7, :future, protocol_subscription: protocol_subscription)
      countbefore = Response.count
      protocol_subscription.cancel!
      expect(Response.count).to eq(countbefore - 7)
      protocol_subscription.responses.each do |respobj|
        expect(respobj.open_from).to be <= Time.zone.now
      end
    end
  end

  describe 'ended?' do
    it 'is ended after the duration of the protocol' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 5.weeks.ago.at_beginning_of_day)
      expect(protocol_subscription).to be_ended
    end
    it 'is not ended when the protocol_subscription is still running' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
      expect(protocol_subscription).not_to be_ended
    end
    it 'is not ended when the protocol_subscription has not yet started' do
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 2.weeks.from_now.at_beginning_of_day)
      expect(protocol_subscription).not_to be_ended
    end
  end

  describe 'start_date' do
    it 'is not nil' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      protocol_subscription.start_date = nil
      expect(protocol_subscription).not_to be_valid
      expect(protocol_subscription.errors.messages).to have_key :start_date
      expect(protocol_subscription.errors.messages[:start_date]).to include('moet opgegeven zijn')
    end
    it 'does not have to be the beginning of a day' do
      not_midnight = Time.new(2017, 4, 10, 12, 0, 0).in_time_zone
      protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: not_midnight)
      expect(protocol_subscription.valid?).to be_truthy
      expect(protocol_subscription.errors.messages).to_not have_key :start_date
    end
  end

  describe 'for_myself?' do
    it 'returns false if it is for someone else' do
      mentor = FactoryBot.create(:mentor)
      student = FactoryBot.create(:student)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: student)
      expect(protocol_subscription).not_to be_for_myself
    end

    it 'returns true if it is for myself' do
      mentor = FactoryBot.create(:mentor)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: mentor)
      expect(protocol_subscription).to be_for_myself
    end
    it 'fills out for myself by default' do
      mentor = FactoryBot.create(:mentor)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor)
      expect(protocol_subscription).to be_for_myself
    end
  end

  describe 'mentor?' do
    it 'returns true if it is for someone else' do
      mentor = FactoryBot.create(:mentor)
      student = FactoryBot.create(:student)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: student)
      expect(protocol_subscription).to be_mentor
    end

    it 'returns false if it is for myself' do
      mentor = FactoryBot.create(:mentor)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor,
                                                filling_out_for: mentor)
      expect(protocol_subscription).not_to be_mentor
    end
    it 'is false by default' do
      mentor = FactoryBot.create(:mentor)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                person: mentor)
      expect(protocol_subscription).not_to be_mentor
    end
  end

  describe 'responses' do
    before do
      Timecop.freeze(Time.zone.local(2017, 3, 19, 0, 0, 0))
    end

    after do
      Timecop.return
    end

    it 'creates responses when you create a protocol subscription' do
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(3)
    end
    it 'creates responses up to the specified offset_till_end' do
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol, offset_till_end: 2.weeks)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(2)
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol, offset_till_end: 1.week)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(3)
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol, offset_till_end: 3.weeks)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(1)
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol, offset_till_end: 4.weeks)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(0)
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol, offset_till_end: 0)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(4)
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol, offset_till_end: nil)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(4)
    end
    it 'deletes the responses when destroying the protocol subscription' do
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      FactoryBot.create(:response, protocol_subscription: protocol_subscription)
      expect(protocol_subscription.responses.first).to be_a(Response)
      responsecountbefore = Response.count
      protocol_subscription.destroy
      expect(Response.count).to eq(responsecountbefore - 1)
    end
    it 'creates responses with a nonvarying open_from' do
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      expect(protocol_subscription.responses.count).to eq(4)
      expect(protocol_subscription.responses[0].open_from).to eq(Time.new(2017, 4, 11, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[1].open_from).to eq(Time.new(2017, 4, 18, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[2].open_from).to eq(Time.new(2017, 4, 25, 13, 0, 0).in_time_zone)
      expect(protocol_subscription.responses[3].open_from).to eq(Time.new(2017, 5, 2, 13, 0, 0).in_time_zone)
    end
    # For this functionality (scheduling relative to the end),
    # we will build in a new property later, and then we can reuse these tests.
    #     it 'should be able to schedule responses relative to the end date' do
    #       protocol = FactoryBot.create(:protocol, duration: 4.weeks)
    #       FactoryBot.create(:measurement, :relative_to_end_date, protocol: protocol)
    #       protocol_subscription = FactoryBot.create(:protocol_subscription,
    #                                                  protocol: protocol,
    #                                                  start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone,
    #                                                  end_date: Time.new(2017, 5, 1, 0, 0, 0).in_time_zone) # 3 weeks
    #       expect(protocol_subscription.responses.count).to eq(1)
    #       expect(protocol_subscription.responses[0].open_from).to(
    #         eq(Time.new(2017, 4, 28, 13, 0, 0).in_time_zone) # + 3.weeks - 2.days - 11.hours
    #       )
    #     end
    #     it 'should be able to handle negative open_from_offsets when changing from summer to winter time' do
    #       protocol = FactoryBot.create(:protocol, duration: 4.weeks)
    #       FactoryBot.create(:measurement, :relative_to_end_date, protocol: protocol)
    #       protocol_subscription = FactoryBot.create(:protocol_subscription,
    #                                                  protocol: protocol,
    #                                                  start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone,
    #                                                  end_date: Time.new(2017, 10, 30, 0, 0, 0).in_time_zone)
    #       expect(protocol_subscription.responses.count).to eq(1)                     # 1 day past dst change
    #       expect(protocol_subscription.responses[0].open_from).to(
    #         eq(Time.new(2017, 10, 27, 13, 0, 0).in_time_zone) # - 2.days - 11.hours
    #       )
    #     end
    #     it 'should be able to handle negative open_from_offsets when changing from winter to summer time' do
    #       protocol = FactoryBot.create(:protocol, duration: 4.weeks)
    #       FactoryBot.create(:measurement, :relative_to_end_date, protocol: protocol)
    #       protocol_subscription = FactoryBot.create(:protocol_subscription,
    #                                                  protocol: protocol,
    #                                                  start_date: Time.new(2017, 3, 19, 0, 0, 0).in_time_zone,
    #                                                  end_date: Time.new(2017, 3, 27, 0, 0, 0).in_time_zone)
    #       expect(protocol_subscription.responses.count).to eq(1)                    # 1 day past dst change
    #       expect(protocol_subscription.responses[0].open_from).to(
    #         eq(Time.new(2017, 3, 24, 13, 0, 0).in_time_zone) # - 2.days - 11.hours
    #       )
    #     end
    it 'does not change the open_from time when changing from winter time to summer time' do
      # changes at 2AM Sunday, March 26 2017
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 3, 20, 0, 0, 0, '+01:00').in_time_zone)
      expect(protocol_subscription.responses.count).to eq(4)
      expect(protocol_subscription.responses[0].open_from).to eq(Time.new(2017, 3, 21, 13, 0, 0, '+01:00').in_time_zone)
      expect(protocol_subscription.responses[1].open_from).to eq(Time.new(2017, 3, 28, 13, 0, 0, '+02:00').in_time_zone)
      expect(protocol_subscription.responses[2].open_from).to eq(Time.new(2017, 4, 4, 13, 0, 0, '+02:00').in_time_zone)
      expect(protocol_subscription.responses[3].open_from).to eq(Time.new(2017, 4, 11, 13, 0, 0, '+02:00').in_time_zone)
    end
    it 'does not change the open_from time when changing from summer time to winter time' do
      # changes at 3AM Sunday, October 29 2017
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 10, 23, 0, 0, 0, '+02:00').in_time_zone)
      expect(protocol_subscription.responses.count).to eq(4)
      expect(protocol_subscription.responses[0].open_from).to eq Time.new(2017, 10, 24, 13, 0, 0, '+02:00').in_time_zone
      expect(protocol_subscription.responses[1].open_from).to eq Time.new(2017, 10, 31, 13, 0, 0, '+01:00').in_time_zone
      expect(protocol_subscription.responses[2].open_from).to eq Time.new(2017, 11, 7, 13, 0, 0, '+01:00').in_time_zone
      expect(protocol_subscription.responses[3].open_from).to eq Time.new(2017, 11, 14, 13, 0, 0, '+01:00').in_time_zone
    end
  end

  describe 'informed_consent_given_at' do
    it 'is nil by default' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription).to be_valid
      expect(protocol_subscription.informed_consent_given_at).to be_nil
    end
    it 'is able to be true' do
      protocol_subscription = FactoryBot.create(:protocol_subscription, informed_consent_given_at: Time.zone.now)
      expect(protocol_subscription).to be_valid
      expect(protocol_subscription.informed_consent_given_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'timestamps' do
    it 'has timestamps for created objects' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(protocol_subscription.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'max_still_earnable_reward_points' do
    it 'is correct for the first three measurements' do
      protocol = FactoryBot.create(:protocol)
      FactoryBot.create(:measurement, protocol: protocol, open_from_offset: (1.day + 11.hours).to_i)
      FactoryBot.create(:measurement, :periodical, protocol: protocol)
      protocol.rewards.create!(threshold: 1, reward_points: 2)
      protocol.rewards.create!(threshold: 3, reward_points: 3)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.zone.now.beginning_of_day)
      expect(protocol_subscription.max_still_earnable_reward_points).to eq 8
    end
  end

  describe 'latest_streak_value_index' do
    it 'is correct' do
      pc = [{ completed: false, periodical: false, reward_points: 1, future: false, streak: -1 },
            { completed: false, periodical: true,  reward_points: 1, future: false, streak: 1 },
            { completed: false, periodical: true,  reward_points: 1, future: true, streak: 2 },
            { completed: false, periodical: true,  reward_points: 1, future: true, streak: 3 }]
      expect_any_instance_of(described_class).to receive(:completion).and_return(pc)
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.latest_streak_value_index).to eq 1
    end
    it 'works when there is no future measurement' do
      pc = [{ completed: false, periodical: false, reward_points: 1, future: false, streak: -1 },
            { completed: false, periodical: true,  reward_points: 1, future: false, streak: 1 },
            { completed: false, periodical: true,  reward_points: 1, future: false, streak: 2 },
            { completed: false, periodical: true,  reward_points: 1, future: false, streak: 3 }]
      expect_any_instance_of(described_class).to receive(:completion).and_return(pc)
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.latest_streak_value_index).to eq(-1)
    end
    it 'works when the first measurement is in the future' do
      pc = [{ completed: false, periodical: false, reward_points: 1, future: true, streak: -1 },
            { completed: false, periodical: true,  reward_points: 1, future: false, streak: 1 },
            { completed: false, periodical: true,  reward_points: 1, future: true, streak: 2 },
            { completed: false, periodical: true,  reward_points: 1, future: false, streak: 3 }]
      expect_any_instance_of(described_class).to receive(:completion).and_return(pc)
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      expect(protocol_subscription.latest_streak_value_index).to eq(-1)
    end
  end

  describe 'protocol_completion' do
    before do
      Timecop.freeze(2017, 4, 1)
    end

    after do
      Timecop.return
    end

    it 'calculates the correct streak' do
      Timecop.freeze(2017, 3, 30, 0, 0, 0)
      protocol_duration = 5.weeks
      protocol = FactoryBot.create(:protocol, duration: protocol_duration)
      FactoryBot.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 1, 0, 0, 0).in_time_zone)

      # Jump to the end of the protocol
      Timecop.freeze(Time.zone.today + protocol_duration)
      protocol_subscription.responses.each_with_index do |responseobj, index|
        next if index == 0 # Pretend the first response is missing

        responseobj.completed_at = responseobj.open_from + 1.minute
      end
      result = protocol_subscription.protocol_completion
      expect(result.length).to eq protocol_subscription.responses.length
      expected = (1..protocol_subscription.responses.length - 1).map do |resp|
        response = protocol_subscription.responses[resp]
        { completed: true, periodical: true, reward_points: 1, future: false, future_or_current: false, streak: resp,
          open_from: response.open_from, questionnaire_key: response.measurement.questionnaire.key }
      end
      expected.unshift(completed: false,
                       periodical: true,
                       reward_points: 1,
                       future: false,
                       future_or_current: false,
                       streak: 0,
                       open_from: protocol_subscription.responses.first.open_from,
                       questionnaire_key: protocol_subscription.responses.first.measurement.questionnaire.key)
      expect(result).to eq expected
      Timecop.return
    end

    it 'calculates the correct streak if there are multiple measurements open' do
      # Measurements start at 9am with an open_duration of 36 hours. So at 12pm (noon), on the third day,
      # the first measurement has expired (since it has been 51 hours since the measurement opened),
      # the second measurement is still open (since it has been 27 hours since the measurement opened),
      # and the third measurement is still open (since it has been 3 hours since the measurement opened).
      # So since only the first measurement expired, and the second and third are open, and the rest is
      # in the future, with 5 measurements total, we expect to see a streak of [0, 1, 2, 3, 4].
      # Before fixing the logic, this would erroneously show a streak of [0, 0, 0, 1, 2] because it
      # counted measurements that were still open as missing.
      Timecop.freeze(2017, 3, 29, 0, 0, 0)
      protocol = FactoryBot.create(:protocol, duration: 5.days)
      FactoryBot.create(:measurement, :periodical_and_overlapping, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 3, 30, 0, 0, 0).in_time_zone)
      Timecop.freeze(2017, 4, 1, 12)
      result = protocol_subscription.protocol_completion
      expect(result.length).to eq protocol_subscription.responses.length
      expected = (1..protocol_subscription.responses.length - 1).map do |resp|
        response = protocol_subscription.responses[resp]
        { completed: false, periodical: true, reward_points: 1, future: true, future_or_current: true, streak: resp,
          open_from: response.open_from, questionnaire_key: response.measurement.questionnaire.key }
      end
      expected.unshift(completed: false,
                       periodical: true,
                       reward_points: 1,
                       future_or_current: false,
                       future: false,
                       streak: 0,
                       open_from: protocol_subscription.responses.first.open_from,
                       questionnaire_key: protocol_subscription.responses.first.measurement.questionnaire.key)
      expect(result).to eq expected
      Timecop.return
    end

    it 'returns -1s if there are no measurements' do
      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 4, 10, 0, 0, 0).in_time_zone)
      result = protocol_subscription.protocol_completion
      expect(result.length).to eq protocol_subscription.responses.length

      expected = (1..protocol_subscription.responses.length).map do |resp|
        response = protocol_subscription.responses[resp - 1]
        { completed: false, periodical: true, reward_points: 1, future: true, future_or_current: true, streak: resp,
          open_from: response.open_from, questionnaire_key: response.measurement.questionnaire.key }
      end

      expect(result).to eq expected
    end

    it 'returns 0 if a measurement was missed' do
      Timecop.freeze(2017, 3, 26, 0, 0, 0)

      protocol = FactoryBot.create(:protocol, duration: 4.weeks)
      FactoryBot.create(:measurement, :periodical, protocol: protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                start_date: Time.new(2017, 3, 27, 0, 0, 0).in_time_zone)

      # Move forward in time to miss a measurement
      Timecop.freeze(2017, 4, 3, 0, 0, 0)
      result = protocol_subscription.protocol_completion
      expect(result.length).to eq protocol_subscription.responses.length
      expected = (1..protocol_subscription.responses.length - 1).map do |resp|
        response = protocol_subscription.responses[resp]
        { completed: false, periodical: true, reward_points: 1, future: true, future_or_current: true, streak: resp,
          open_from: response.open_from, questionnaire_key: response.measurement.questionnaire.key }
      end
      expected.unshift(completed: false,
                       periodical: true,
                       reward_points: 1,
                       future_or_current: false,
                       future: false,
                       streak: 0,
                       open_from: protocol_subscription.responses.first.open_from,
                       questionnaire_key: protocol_subscription.responses.first.measurement.questionnaire.key)

      expect(result).to eq expected
      Timecop.return
    end
  end

  describe 'needs_informed_consent?' do
    it 'returns true if the informed consent is not yet provided for a protocol' do
      protocol = FactoryBot.create(:protocol, :with_informed_consent_questionnaire)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol)

      expect(protocol_subscription.informed_consent_given_at).to be_nil
      expect(protocol_subscription).to be_needs_informed_consent
    end

    it 'returns false if the protocol does not require informed consent' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol)
      expect(protocol_subscription).not_to be_needs_informed_consent
    end

    it 'returns false if informed consent was given' do
      protocol = FactoryBot.create(:protocol, :with_informed_consent_questionnaire)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                protocol: protocol,
                                                informed_consent_given_at: 10.days.ago)
      expect(protocol_subscription).not_to be_needs_informed_consent
    end
  end
end
