# frozen_string_literal: true

require 'rails_helper'

describe InvitationSet do
  it 'should have valid default properties' do
    invitation_set = FactoryBot.build(:invitation_set)
    expect(invitation_set.valid?).to be_truthy
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

  describe 'invitation_text' do
    it 'can be set to nil' do
      invitation_set = FactoryBot.build(:invitation_set, invitation_text: nil)
      expect(invitation_set.valid?).to be_truthy
    end
    it 'can be set to a string' do
      invitation_set = FactoryBot.create(:invitation_set, invitation_text: 'some text')
      expect(invitation_set.invitation_text).to eq 'some text'
    end
  end

  describe 'invitation_tokens' do
    it 'should destroy the invitation_tokens when destroying the invitation_set' do
      invitation_set = FactoryBot.create(:invitation_set)
      FactoryBot.create(:invitation_token, invitation_set: invitation_set)
      expect(invitation_set.invitation_tokens.first).to be_a(InvitationToken)
      invtokencountbefore = InvitationToken.count
      invitation_set.destroy
      expect(InvitationToken.count).to eq(invtokencountbefore - 1)
    end
  end

  describe 'invitations' do
    it 'should destroy the invitations when destroying the invitation_set' do
      invitation_set = FactoryBot.create(:invitation_set)
      FactoryBot.create(:invitation, invitation_set: invitation_set)
      expect(invitation_set.invitations.first).to be_a(Invitation)
      invcountbefore = Invitation.count
      invitation_set.destroy
      expect(Invitation.count).to eq(invcountbefore - 1)
    end
  end

  describe 'responses' do
    it 'should be available through the invitation-set' do
      invitation_set = FactoryBot.create(:invitation_set)
      FactoryBot.create(:response, invitation_set: invitation_set)
      expect(invitation_set.responses.first).to be_a(Response)
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      invitation_set = FactoryBot.create(:invitation_set)
      expect(invitation_set.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(invitation_set.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
