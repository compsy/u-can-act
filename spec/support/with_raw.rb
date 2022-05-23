# frozen_string_literal: true

RSpec.shared_context 'with raw', shared_context: :metadata do
  before do
    question[:raw] = question.deep_dup
  end
end
