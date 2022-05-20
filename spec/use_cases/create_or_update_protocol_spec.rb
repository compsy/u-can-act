# frozen_string_literal: true

require 'rails_helper'

describe CreateOrUpdateProtocol do
  let(:name) { 'name' }
  let(:duration) { 1 }
  let(:invitation_text) { 'you are invited' }
  let(:informed_consent_questionnaire_key) { nil } # It should be okay for this to be blank

  let(:questionnaire1_key) { 'questionnaire1_key' }
  let!(:questionnaire1) { FactoryBot.create :questionnaire, key: questionnaire1_key }

  let(:questionnaires) do
    [
      {
        key: questionnaire1_key,
        measurement: {
          open_from_offset: 1,
          open_from_day: 'monday',
          period: 1,
          open_duration: 1,
          reminder_delay: 1,
          priority: 1,
          stop_measurement: true,
          should_invite: true,
          only_redirect_if_nothing_else_ready: true
        }
      }
    ]
  end

  let!(:protocol) { FactoryBot.create :protocol, name: name }

  subject do
    described_class.run name: name,
                        duration: duration,
                        invitation_text: invitation_text,
                        informed_consent_questionnaire_key: informed_consent_questionnaire_key,
                        questionnaires: questionnaires
  end

  describe 'validations' do
    context 'when the name, the duration, the invitation_text and the questionnaires are present' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end
    context 'when one of the required parameters is missing' do
      let(:duration) { nil }
      it 'is not valid' do
        expect(subject)
      end
    end
    context 'when a questionnaire is missing an attribute' do
      let(:questionnaires) { [{ another_attr: 'value' }] }
      it 'is not valid' do
        expect(subject).not_to be_valid
      end
    end
    context 'when a measurement is missing an attribute' do
      let(:questionnaires) { [{ key: questionnaire1.key, measurement: { another_attr: 'value' } }] }
      it 'is not valid' do
        expect(subject).not_to be_valid
      end
    end
  end

  describe 'run' do
    context 'when the protocol doesn\'t exist' do
      let!(:protocol) { nil }
      it 'creates it' do
        expect { subject }.to change(Protocol, :count).by(1)
      end
    end
    context 'when the protocol exists' do
      it 'updates it' do
        expect { subject }.not_to change(Protocol, :count)
        protocol.reload
        expect(protocol.invitation_text).to eq invitation_text
      end
    end
    context 'when the informed_consent_questionnaire_key key is given' do
      let!(:ic_questionnaire) { FactoryBot.create :questionnaire }
      let(:informed_consent_questionnaire_key) { ic_questionnaire.key }

      it 'is assigned to the protocol' do
        expect { subject }.to change {
          protocol.reload
          protocol.informed_consent_questionnaire&.id
        }.to(ic_questionnaire.id)
      end
    end
    context 'when an invalid informed_consent_questionnaire_key is given' do
      let!(:ic_questionnaire) { FactoryBot.create :questionnaire, key: 'ic_key' }
      let(:informed_consent_questionnaire_key) { 'non_existent_key' }
      it 'returns an error' do
        res = subject
        expect(res).not_to be_valid
        expect(res.errors).not_to be_empty
      end
    end
    context 'when the questionnaire exists' do
      it 'assigns the measurements to the protocol' do
        expect { subject }.to change {
          protocol.reload
          protocol.measurements.count
        }.from(0).to(1)
      end
    end
    context 'when the questionnaire does not exist' do
      let!(:questionnaire1) { nil }
      it 'returns an error' do
        res = subject
        expect(res).not_to be_valid
        expect(res.errors).not_to be_empty
      end
    end
    context 'when the protocol is not valid' do
      let(:duration) { -1 }
      it 'combines the errors' do
        res = subject
        expect(res).not_to be_valid
      end
    end
    context 'when one of the measurements is not valid' do
      let(:questionnaire2) { FactoryBot.create :questionnaire }
      let(:questionnaires) do
        [
          {
            key: questionnaire1_key,
            measurement: {
              open_from_offset: 1,
              open_from_day: 'monday',
              period: 1,
              open_duration: 1,
              reminder_delay: 1,
              priority: 1,
              stop_measurement: true,
              should_invite: true,
              only_redirect_if_nothing_else_ready: true
            }
          },
          {
            key: questionnaire2.key,
            measurement: {
              open_from_offset: 1,
              open_from_day: 'monday',
              period: 1,
              open_duration: 1,
              reminder_delay: 1,
              priority: 1,
              stop_measurement: true, # having 2 stop measurements is not allowed, this should fail
              should_invite: true,
              only_redirect_if_nothing_else_ready: true
            }
          }
        ]
      end
      it 'combines the errors' do
        res = subject
        expect(res).not_to be_valid
      end
    end
    context 'when the measurement is not valid' do
      let(:questionnaires) do
        [
          {
            key: 'non_existing_key', # This makes the measurement invalid and should cancel the transaction
            measurement: {
              open_from_offset: 1,
              open_from_day: 'monday',
              period: 1,
              open_duration: 1,
              reminder_delay: 1,
              priority: 1,
              stop_measurement: true,
              should_invite: true,
              only_redirect_if_nothing_else_ready: true
            }
          }
        ]
      end
      let!(:protocol) { nil } # Override the protocol above so no protocol exists so we can test if it was created
      it 'rolls back the protocol, no protocol gets created, action is atomic' do
        expect { subject }.not_to change(Protocol, :count)
      end
    end
  end
end
