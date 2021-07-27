# frozen_string_literal: true

require 'rails_helper'

describe DestroyFutureResponsesJob do
  describe '#perform_later' do
    it 'performs something later' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later(1)
      end.to have_enqueued_job(described_class)
    end
  end

  describe 'perform' do
    it 'destroys future responses' do
      protocol_subscription = FactoryBot.create(:protocol_subscription)
      response_id = FactoryBot.create(:response,
                                      protocol_subscription: protocol_subscription,
                                      open_from: 1.hour.from_now).id
      FactoryBot.create(:response,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.hour.ago).id
      expect do
        described_class.perform_now(response_id)
      end.to change(Response, :count).by(-1)
      expect(Response.find_by(id: response_id)).to be_blank
    end
  end

  describe 'max_attempts' do
    it 'is two' do
      expect(subject.max_attempts).to eq 2
    end
  end

  describe 'reschedule_at' do
    it 'is in one hour' do
      time_now = Time.zone.now
      expect(subject.reschedule_at(time_now, 1)).to be_within(1.minute)
        .of(TimeTools.increase_by_duration(time_now, 5.minutes))
    end
  end
end
