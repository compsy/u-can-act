# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SupervisionTrajectory, type: :model do
  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:supervision_trajectory)).to be_valid
    end

    describe 'protocols' do
      describe 'protocol_for_mentor' do
        it 'should allow nil' do
          expect(FactoryBot.build(:supervision_trajectory, protocol_for_mentor: nil)).to be_valid
        end

        it 'should allow duplicate nils' do
          FactoryBot.create(:supervision_trajectory, protocol_for_mentor: nil)
          expect(FactoryBot.build(:supervision_trajectory, protocol_for_mentor: nil)).to be_valid
        end

        it 'should allow a protocol_for_mentor to be reused in other supervision trajectories' do
          protocol_for_mentor = FactoryBot.create(:protocol)
          protocol_for_student = FactoryBot.create(:protocol)
          protocol_for_student2 = FactoryBot.create(:protocol)
          expect do
            FactoryBot.create(:supervision_trajectory,
                              protocol_for_student: protocol_for_student,
                              protocol_for_mentor: protocol_for_mentor)
          end.to_not raise_error
          traj = FactoryBot.build(:supervision_trajectory,
                                  protocol_for_student: protocol_for_student2,
                                  protocol_for_mentor: protocol_for_mentor)
          expect(traj).to be_valid
        end
      end

      describe 'protocol_for_student' do
        it 'should allow nil' do
          expect(FactoryBot.build(:supervision_trajectory, protocol_for_student: nil)).to be_valid
        end

        it 'should allow duplicate nils' do
          FactoryBot.create(:supervision_trajectory, protocol_for_student: nil)
          expect(FactoryBot.build(:supervision_trajectory, protocol_for_student: nil)).to be_valid
        end

        it 'should allow a protocol_for_student to be reused in other supervision trajectories' do
          protocol_for_mentor = FactoryBot.create(:protocol)
          protocol_for_mentor2 = FactoryBot.create(:protocol)
          protocol_for_student = FactoryBot.create(:protocol)
          expect do
            FactoryBot.create(:supervision_trajectory,
                              protocol_for_student: protocol_for_student,
                              protocol_for_mentor: protocol_for_mentor)
          end.to_not raise_error
          traj = FactoryBot.build(:supervision_trajectory,
                                  protocol_for_student: protocol_for_student,
                                  protocol_for_mentor: protocol_for_mentor2)
          expect(traj).to be_valid
        end
        it 'should raise if the same protocol-combination is assigned twice' do
          protocol_for_mentor = FactoryBot.create(:protocol)
          protocol_for_student = FactoryBot.create(:protocol)
          expect do
            FactoryBot.create(:supervision_trajectory,
                              protocol_for_student: protocol_for_student,
                              protocol_for_mentor: protocol_for_mentor)
          end.to_not raise_error
          traj = FactoryBot.build(:supervision_trajectory,
                                  protocol_for_student: protocol_for_student,
                                  protocol_for_mentor: protocol_for_mentor)
          expect(traj).to_not be_valid
          expect(traj.errors.messages).to have_key :protocol_for_mentor
          expect(traj.errors.messages[:protocol_for_mentor]).to include('is al in gebruik')
        end
      end

      describe 'name' do
        it 'should have a name' do
          traj = FactoryBot.build(:supervision_trajectory, name: nil)
          expect(traj).to_not be_valid
          expect(traj.errors.messages).to have_key :name
          expect(traj.errors.messages[:name]).to include('moet opgegeven zijn')
        end

        it 'should have a name in the db' do
          traj = FactoryBot.build(:supervision_trajectory, name: nil)
          expect { traj.save(validate: false) }.to raise_error(ActiveRecord::StatementInvalid)
        end

        it 'should have a unique name' do
          FactoryBot.create(:supervision_trajectory, name: 'test')
          traj = FactoryBot.build(:supervision_trajectory, name: 'test')
          expect(traj).to_not be_valid
          expect(traj.errors.messages).to have_key :name
          expect(traj.errors.messages[:name]).to include('is al in gebruik')
        end
      end
    end
  end
  describe 'subscribe!' do
    let(:student) { FactoryBot.create(:student) }
    let(:mentor) { FactoryBot.create(:mentor) }

    it 'should subscribe both a student and a mentor to the protocols' do
      pre_prot_subs = ProtocolSubscription.count
      traj = FactoryBot.create(:supervision_trajectory,
                               :with_protocol_for_mentor,
                               :with_protocol_for_student,
                               name: 'test')
      traj.subscribe!(mentor: mentor, student: student,
                      start_date: 10.hours.ago.in_time_zone.beginning_of_day,
                      end_date: 10.days.from_now.beginning_of_day)

      # Expect 1 for the mentor and 1 for the student
      expect(ProtocolSubscription.count).to eq(pre_prot_subs + 2)
    end

    it 'should be able to only subscribe a mentor' do
      start = 10.hours.ago.in_time_zone.beginning_of_day
      endd = 10.days.from_now.beginning_of_day

      pre_prot_subs = ProtocolSubscription.count
      traj = FactoryBot.create(:supervision_trajectory, :with_protocol_for_mentor, name: 'test')
      traj.subscribe!(mentor: mentor, student: student,
                      start_date: start,
                      end_date: endd)

      expect(ProtocolSubscription.count).to eq(pre_prot_subs + 1)
      prot_sub = ProtocolSubscription.last
      expect(prot_sub.protocol).to eq(traj.protocol_for_mentor)
      expect(prot_sub.start_date).to eq start
      expect(prot_sub.end_date).to eq endd
      expect(prot_sub.filling_out_for).to eq student
      expect(prot_sub.person).to eq mentor
    end

    it 'should be able to only subscribe a student' do
      start = 10.hours.ago.in_time_zone.beginning_of_day
      endd = 10.days.from_now.beginning_of_day

      pre_prot_subs = ProtocolSubscription.count
      traj = FactoryBot.create(:supervision_trajectory, :with_protocol_for_student, name: 'test')
      traj.subscribe!(mentor: mentor, student: student,
                      start_date: start,
                      end_date: endd)

      # Expect 1 for the mentor and 1 for the student
      expect(ProtocolSubscription.count).to eq(pre_prot_subs + 1)
      prot_sub = ProtocolSubscription.last
      expect(prot_sub.protocol).to eq(traj.protocol_for_student)
      expect(prot_sub.start_date).to eq start
      expect(prot_sub.end_date).to eq endd
      expect(prot_sub.filling_out_for).to eq student
      expect(prot_sub.person).to eq student
    end
  end
end
