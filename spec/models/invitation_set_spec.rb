# frozen_string_literal: true

require 'rails_helper'

describe InvitationSet do
  it 'has valid default properties' do
    invitation_set = FactoryBot.create(:invitation_set)
    expect(invitation_set).to be_valid
  end

  describe 'person' do
    it 'has one' do
      invitation_set = FactoryBot.create(:invitation_set)
      invitation_set.person_id = nil
      expect(invitation_set).not_to be_valid
      expect(invitation_set.errors.messages).to have_key :person
      expect(invitation_set.errors.messages[:person]).to include('moet opgegeven zijn')
    end
    it 'works to retrieve a Person' do
      invitation_set = FactoryBot.create(:invitation_set)
      expect(invitation_set.person).to be_a(Person)
    end
  end

  describe 'invitation_text' do
    it 'can be set to nil' do
      invitation_set = FactoryBot.create(:invitation_set)
      invitation_set.invitation_text = nil
      expect(invitation_set).to be_valid
    end
    it 'can be set to a string' do
      invitation_set = FactoryBot.create(:invitation_set, invitation_text: 'some text')
      expect(invitation_set.invitation_text).to eq 'some text'
    end
  end

  describe 'invitation_tokens' do
    it 'destroys the invitation_tokens when destroying the invitation_set' do
      invitation_set = FactoryBot.create(:invitation_set)
      FactoryBot.create(:invitation_token, invitation_set: invitation_set)
      expect(invitation_set.invitation_tokens.first).to be_a(InvitationToken)
      invtokencountbefore = InvitationToken.count
      invitation_set.destroy
      expect(InvitationToken.count).to eq(invtokencountbefore - 1)
    end
  end

  describe 'invitations' do
    it 'destroys the invitations when destroying the invitation_set' do
      invitation_set = FactoryBot.create(:invitation_set)
      FactoryBot.create(:sms_invitation, invitation_set: invitation_set)
      expect(invitation_set.invitations.first).to be_a(Invitation)
      invcountbefore = Invitation.count
      invitation_set.destroy
      expect(Invitation.count).to eq(invcountbefore - 1)
    end
  end

  describe 'responses' do
    it 'is available through the invitation_set' do
      invitation_set = FactoryBot.create(:invitation_set)
      FactoryBot.create(:response, invitation_set: invitation_set)
      expect(invitation_set.responses.first).to be_a(Response)
    end
  end

  describe 'timestamps' do
    it 'has timestamps for created objects' do
      invitation_set = FactoryBot.create(:invitation_set)
      expect(invitation_set.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(invitation_set.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'invitation_url' do
    it 'returns the correct invitation_url for a response' do
      responseobj = FactoryBot.create(:response, :invited)
      token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      pt_token = token.token_plain
      expect(pt_token).not_to be_blank
      expect(responseobj.invitation_set.invitation_tokens.first.token_plain).to be_blank
      responseobj.reload
      expect(responseobj.invitation_set.invitation_tokens.first.token_plain).to be_blank
      result = responseobj.invitation_set.invitation_url(pt_token)
      expect(result).to match pt_token
      expect(result).not_to match token.token_hash
      expect(result).to match responseobj.protocol_subscription.person.external_identifier
      expect(result).to eq "#{ENV['HOST_URL']}/"\
                           "?q=#{responseobj.protocol_subscription.person.external_identifier}#{pt_token}"
    end

    it 'raises if called for a previously stored token' do
      responseobj = FactoryBot.create(:response, :invited)
      FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      responseobj.reload
      expect(responseobj.invitation_set.invitation_tokens.first).not_to be_blank
      expect(responseobj.invitation_set.invitation_tokens.first.token_plain).to be_blank
      expect do
        responseobj.invitation_set.invitation_url(responseobj.invitation_set.invitation_tokens.first.token_plain)
      end.to raise_error(RuntimeError, 'Cannot generate invitation_url for historical invitation tokens!')
    end
  end

  describe 'reminder_delay' do
    it 'should get the reminder delay of an associated response' do
      measurement = FactoryBot.create(:measurement, reminder_delay: 3.hours + 2.minutes + 1.second)
      responseobj = FactoryBot.create(:response, :invited, measurement: measurement)
      expect(responseobj.invitation_set.reminder_delay).to_not be_blank
      expect(responseobj.invitation_set.reminder_delay).to eq measurement.reminder_delay
    end

    it 'should pick the minimum reminder delay when there are multiple associated responses' do
      measurement1 = FactoryBot.create(:measurement, reminder_delay: 3.hours + 2.minutes + 1.second)
      responseobj1 = FactoryBot.create(:response, measurement: measurement1)

      measurement2 = FactoryBot.create(:measurement, reminder_delay: 4.hours + 2.minutes + 1.second)
      responseobj2 = FactoryBot.create(:response, measurement: measurement2)

      measurement3 = FactoryBot.create(:measurement, reminder_delay: 5.hours + 2.minutes + 1.second)
      responseobj3 = FactoryBot.create(:response, measurement: measurement3)

      invitation_set = FactoryBot.create(:invitation_set, responses: [responseobj1, responseobj2, responseobj3])
      expect(invitation_set.reminder_delay).to_not be_blank
      expect(invitation_set.reminder_delay).to eq measurement1.reminder_delay
    end

    it 'should pick the minimum reminder delay even with nil values' do
      measurement1 = FactoryBot.create(:measurement, reminder_delay: nil)
      responseobj1 = FactoryBot.create(:response, measurement: measurement1)

      measurement2 = FactoryBot.create(:measurement, reminder_delay: 4.hours + 2.minutes + 1.second)
      responseobj2 = FactoryBot.create(:response, measurement: measurement2)

      measurement3 = FactoryBot.create(:measurement, reminder_delay: 5.hours + 2.minutes + 1.second)
      responseobj3 = FactoryBot.create(:response, measurement: measurement3)

      invitation_set = FactoryBot.create(:invitation_set, responses: [responseobj1, responseobj2, responseobj3])
      expect(invitation_set.reminder_delay).to_not be_blank
      expect(invitation_set.reminder_delay).to eq measurement2.reminder_delay
    end

    it 'should return the default if there are no reminder delays present' do
      measurement1 = FactoryBot.create(:measurement, reminder_delay: nil)
      responseobj1 = FactoryBot.create(:response, measurement: measurement1)

      invitation_set = FactoryBot.create(:invitation_set, responses: [responseobj1])
      expect(invitation_set.reminder_delay).to_not be_blank
      expect(invitation_set.reminder_delay).to eq Measurement::DEFAULT_REMINDER_DELAY
    end
  end
end
