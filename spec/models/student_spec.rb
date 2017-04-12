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
end
