# frozen_string_literal: true

require 'rails_helper'

describe ExpandableGenerator do
  let!(:question) do
    {
      id: :v1,
      type: :expandable,
      title: 'Activiteiten',
      default_expansions: 1,
      max_expansions: 2,
      content: [
        {
          id: :v2,
          type: :checkbox,
          title: 'Wat heeft u gedaan?',
          options: %w[fietsen lopen]
        }
      ]
    }
  end

  it_behaves_like 'a generator'

  describe 'sub questions' do
    include_context 'with raw'

    it 'renders every expansion' do
      result = subject.generate(question)
      expect(result).to include('name="content[v2_0_fietsen]"')
      expect(result).to include('name="content[v2_1_lopen]"')
    end

    it 'stores the otherwise option of fi users with the Dutch key' do
      result = I18n.with_locale(:fi) { subject.generate(question.merge(locale: 'fi')) }
      expect(result).to include('name="content[v2_0_anders_namelijk]"')
      expect(result).not_to include('muu_mika')
      # The shown label is still Finnish.
      expect(result).to include('Muu, mikä:')
    end

    it 'keeps the en key of the otherwise option for en users' do
      result = I18n.with_locale(:en) { subject.generate(question.merge(locale: 'en')) }
      expect(result).to include('name="content[v2_0_otherwise_please_specify]"')
    end

    it 'renders the sub questions in the locale of the question' do
      result = subject.generate(question.merge(locale: 'en'))
      expect(result).to include('Otherwise (please specify):')
      expect(result).not_to include('Anders, namelijk:')
    end
  end
end
