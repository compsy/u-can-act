# frozen_string_literal: true

require 'rails_helper'

describe Api::RoleSerializer do
  let!(:the_subject) { FactoryBot.create(:role) }
  before { the_subject.reload }

  subject(:json) { described_class.new(the_subject).as_json.with_indifferent_access }

  describe 'renders the correct json' do
    it 'should contain the correct variables' do
      expect(json).to_not be_nil
      expect(json.keys).to match_array %w[uuid title group]
    end

    it 'should contain the correct value for the uuid' do
      expect(the_subject.uuid).to_not be_blank
      expect(json['uuid']).to eq the_subject.uuid
    end

    it 'should contain the correct value for the title' do
      expect(the_subject.title).to_not be_blank
      expect(json['title']).to eq the_subject.title
    end

    it 'should contain the correct value for the group' do
      expect(the_subject.group).to_not be_blank
      expect(json['group']).to eq the_subject.group
    end
  end
end
