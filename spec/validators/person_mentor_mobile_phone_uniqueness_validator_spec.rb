# frozen_string_literal: true

require 'rails_helper'

describe PersonMentorMobilePhoneUniquenessValidator do
  it 'should not give errors when updating an existing protsub' do
    mentor = FactoryBot.create(:mentor)
    student = FactoryBot.create(:student)
    prot_sub = FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
    prot_sub.update_attributes!(end_date: Time.zone.now)
  end

  it 'should return errors if the mentor is already supervising a student with this mobile phone number' do
    mentor = FactoryBot.create(:mentor)
    student = FactoryBot.create(:student)
    student2 = FactoryBot.create(:student, mobile_phone: student.mobile_phone)
    FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
    prot_sub = FactoryBot.build(:protocol_subscription, person: mentor, filling_out_for: student2)
    expect(subject.validate(prot_sub)).to_not be_nil
    expect(prot_sub.errors).to_not be_blank
    expect(prot_sub.errors.messages).to have_key :filling_out_for_id
    expect(prot_sub.errors.messages[:filling_out_for_id]).to include('telefoonnummer is al in gebruik')
  end

  it 'should be possible to have two prot subs for the same student' do
    mentor = FactoryBot.create(:mentor)
    student = FactoryBot.create(:student)
    FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
    prot_sub = FactoryBot.build(:protocol_subscription, person: mentor, filling_out_for: student)
    expect(subject.validate(prot_sub)).to be_nil
    expect(prot_sub.errors).to be_blank
  end

  it 'should not generate errors when the person is filling out a questionnaire for him/herself' do
    mentor = FactoryBot.create(:mentor)
    prot_sub = FactoryBot.build(:protocol_subscription, person: mentor, filling_out_for: mentor)
    expect(subject.validate(prot_sub)).to be_nil
    expect(prot_sub.errors).to be_blank
  end

  it 'should return nil if the mentor is supervising other students with different phone numbers' do
    mentor = FactoryBot.create(:mentor)
    student = FactoryBot.create(:student)
    student2 = FactoryBot.create(:student)
    FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student)
    prot_sub = FactoryBot.build(:protocol_subscription, person: mentor, filling_out_for: student2)
    expect(subject.validate(prot_sub)).to be_nil
    expect(prot_sub.errors).to be_blank
  end

  it 'should return nil if the mentor is not yet supervising other students' do
    mentor = FactoryBot.create(:mentor)
    student = FactoryBot.create(:student)
    prot_sub = FactoryBot.build(:protocol_subscription, person: mentor, filling_out_for: student)
    expect(subject.validate(prot_sub)).to be_nil
    expect(prot_sub.errors).to be_blank
  end
end
