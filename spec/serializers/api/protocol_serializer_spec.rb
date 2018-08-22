# frozen_string_literal: true

require 'rails_helper'

describe Api::ProtocolSerializer do
  let!(:the_subject) { FactoryBot.create(:protocol) }
  before { the_subject.reload }

  subject(:json) { described_class.new(the_subject).as_json.with_indifferent_access }

  describe 'renders the correct json' do
    it 'should contain the correct variables' do
      expect(json).to_not be_nil
      expect(json.keys).to match_array %w[uuid name]
    end

    it 'should contain the correct value for the uuid' do
      expect(the_subject.uuid).to_not be_blank
      expect(json['uuid']).to eq the_subject.uuid
    end

    it 'should contain the correct value for the name' do
      expect(the_subject.name).to_not be_blank
      expect(json['name']).to eq the_subject.name
    end
  end
end
