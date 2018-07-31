# frozen_string_literal: true

require 'rails_helper'

describe GenerateInvitationText do
  describe 'run' do
    describe 'protocol with invitation text' do
      it 'should return the text of a protocol if one is set' do
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        result = described_class.run!(response: response)
        expect(result).to be_a String
        expect(result).to eq protocol.invitation_text
      end

      it 'should evaluate the values in the the text of a protocol' do
        protocol = FactoryBot.create(:protocol, :with_invitation_text)
        protocol_subscription = FactoryBot.create(:protocol_subscription, protocol: protocol)
        response = FactoryBot.create(:response, protocol_subscription: protocol_subscription)

        subs_hash = {}
        expected = 'expected outcome'
        expect(VariableSubstitutor).to receive(:substitute_variables)
          .with(response).and_return(subs_hash)
        expect(VariableEvaluator).to receive(:evaluate_obj)
          .with(protocol.invitation_text, subs_hash)
          .and_return(expected)

        result = described_class.run!(response: response)
        expect(result).to eq expected
      end
    end

    describe 'protocol without invitation text' do
      describe 'student' do
        let(:protocol) { FactoryBot.create(:protocol) }
        let(:student) { FactoryBot.create(:student) }
        let(:protocol_subscription) do
          FactoryBot.create(:protocol_subscription,
                            end_date: 10.days.from_now,
                            protocol: protocol, person: student)
        end
        let(:response) { FactoryBot.create(:response, protocol_subscription: protocol_subscription) }

        it 'should call the student invitation texts generator' do
          expected = 'test'
          result = double('result')
          allow(result).to receive(:response).and_return('result' => { 'payload' => expected })
          expect(Compsy::MicroserviceApi::CallService).to receive(:run!)
            .with(action: 'svc-messages',
                  namespace: ENV['MICROSERVICE_NAMESPACE'],
                  parameters: subject.send(:generate_hash, response))
            .and_return(result)
          result = described_class.run!(response: response)
          expect(result).to eq(expected)
        end
      end
    end
  end
end
