# frozen_string_literal: true

require 'rails_helper'

describe Mentor do
  it_should_behave_like 'a person object'

  it 'should have working factory defaults' do
    mentor = FactoryGirl.build(:mentor)
    pcountb = Person.count
    mcountb = Mentor.count
    expect(mentor.valid?).to be_truthy
    expect(mentor.type).to eq 'Mentor'
    mentor.save
    expect(Person.count).to eq(pcountb + 1)
    expect(Mentor.count).to eq(mcountb + 1)
  end

  describe 'type' do
    let(:mentor) { FactoryGirl.build(:mentor) }
    it 'should be set on a build' do
      expect(mentor.type).to eq 'Mentor'
    end
    it 'should be saved on a create' do
      mentor.save
      mentor.reload
      expect(mentor.type).to eq 'Mentor'
      expect(Person.last.type).to eq 'Mentor'
    end
  end
end
