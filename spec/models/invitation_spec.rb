# frozen_string_literal: true

require 'rails_helper'

describe Invitation do
  it 'should have valid default properties' do
    invitation = FactoryBot.build(:invitation)
    expect(invitation.valid?).to be_truthy
  end
  it 'should have valid default properties for email type' do
    invitation = FactoryBoy.build(:invitation, :email)
    expect(invitation.valid?).to be_truthy
  end

  describe 'person' do
    it 'should have one' do
      invitation_set = FactoryBot.build(:invitation_set, person_id: nil)
      expect(invitation_set.valid?).to be_falsey
      expect(invitation_set.errors.messages).to have_key :person_id
      expect(invitation_set.errors.messages[:person_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Person' do
      invitation_set = FactoryBot.create(:invitation_set)
      expect(invitation_set.person).to be_a(Person)
    end
  end

  describe 'type' do
    it 'cannot be set to nil' do
      invitation = FactoryBot.build(:invitation, type: nil)
      expect(invitation.valid?).to be_falsey
    end
    it 'cannot be set to any string' do
      invitation = FactoryBot.build(:invitation, type: 'someklass')
      expect(invitation.valid?).to be_falsey
    end
  end

  describe 'invited_state' do
    it 'should be one of the predefined states' do
      invitation = FactoryBot.build(:invitation)
      invitation.invited_state = Invitation::NOT_SENT_STATE
      expect(invitation.valid?).to be_truthy
      invitation = FactoryBot.build(:invitation)
      invitation.invited_state = Invitation::SENDING_STATE
      expect(invitation.valid?).to be_truthy
      invitation = FactoryBot.build(:invitation)
      invitation.invited_state = Invitation::SENT_STATE
      expect(invitation.valid?).to be_truthy
    end
    it 'should not be nil' do
      invitation = FactoryBot.build(:invitation, invited_state: nil)
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invited_state
      expect(invitation.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'should not be empty' do
      invitation = FactoryBot.build(:invitation, invited_state: '')
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invited_state
      expect(invitation.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
    it 'cannot be just any string' do
      invitation = FactoryBot.build(:invitation, invited_state: 'somestring')
      expect(invitation.valid?).to be_falsey
      expect(invitation.errors.messages).to have_key :invited_state
      expect(invitation.errors.messages[:invited_state]).to include('is niet in de lijst opgenomen')
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      invitation = FactoryBot.create(:invitation)
      expect(invitation.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(invitation.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
