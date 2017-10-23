# frozen_string_literal: true

require 'rails_helper'

describe Student do
  it_should_behave_like 'a person object'

  it 'should have working factory defaults' do
    student = FactoryGirl.build(:student)
    pcountb = Person.count
    scountb = Student.count
    expect(student.valid?).to be_truthy
    expect(student.type).to eq 'Student'
    student.save
    expect(Person.count).to eq(pcountb + 1)
    expect(Student.count).to eq(scountb + 1)
  end

  describe 'type' do
    let(:student) { FactoryGirl.build(:student) }
    it 'should be set on a build' do
      expect(student.type).to eq 'Student'
    end
    it 'should be saved on a create' do
      student.save
      student.reload
      expect(student.type).to eq 'Student'
      expect(Person.last.type).to eq 'Student'
    end
  end

  describe 'mentor' do
    it 'should give a warning when a student has multiple mentors' do
      student = FactoryGirl.create(:student)
      mentor1 = FactoryGirl.create(:mentor)
      mentor2 = FactoryGirl.create(:mentor)
      FactoryGirl.create(:protocol_subscription, person: mentor1, filling_out_for: student)
      FactoryGirl.create(:protocol_subscription, person: mentor2, filling_out_for: student)
      expect(Rails.logger).to receive(:warn)
        .with("[Attention] retrieving one of multiple mentors for student: #{student.id}")
      expect(student.mentor).to eq(mentor1)
    end
    it 'should give a warning when a student has multiple mentors' do
      student = FactoryGirl.create(:student)
      mentor = FactoryGirl.create(:mentor)
      FactoryGirl.create(:protocol_subscription, person: mentor, filling_out_for: student)
      expect(Rails.logger).not_to receive(:warn)
      expect(student.mentor).to eq(mentor)
    end
  end
end
