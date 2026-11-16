# frozen_string_literal: true

require 'rails_helper'

# Regression check for N-language questionnaire support: every questionnaire seed of every project, both the
# single-language (Dutch) ones and the ones with language keys, renders in nl, en and in locales that fall back
# (fi, de). The names and values of the form fields become the keys and values of the stored answers, so they must
# not depend on the locale: answers are stored with the Dutch values.
describe 'questionnaire seeds' do
  fallback_locales = %w[fi de].freeze
  locales = (%w[nl en] + fallback_locales).freeze
  # Hidden fields that are not answers or that record the locale on purpose.
  ignored_fields = %w[utf8 response_id content[locale]].freeze

  # Loads the questionnaire seeds of a project. A few seeds look up questionnaires of other seeds, so seeds that fail
  # are retried after the others.
  def load_questionnaire_seeds(project)
    pending_files = Rails.root.glob("projects/#{project}/seeds/questionnaires/**/*.rb")
    until pending_files.empty?
      failed_files = pending_files.reject { |file| load_seed(file) }
      raise "Could not load the questionnaire seeds #{failed_files}" if failed_files.size == pending_files.size

      pending_files = failed_files
    end
  end

  def load_seed(file)
    load file
    true
  rescue RuntimeError => e
    raise unless e.message.include?('not found')

    false
  end

  # Like QuestionnaireController, which also sets I18n.locale to the locale of the person.
  def render_questionnaire(response, locale)
    questionnaire = response.measurement.questionnaire
    I18n.with_locale(locale) do
      QuestionnaireGenerator.new.generate_questionnaire(
        response_id: response.id,
        content: questionnaire.content,
        title: questionnaire.title,
        submit_text: I18n.t('questionnaires.save', locale: locale),
        action: '/',
        unsubscribe_url: response.unsubscribe_url,
        locale: locale
      )
    end
  end

  # The fields a browser would submit: [name, value] pairs, where the value is only included when it is fixed in the
  # page (options of radios, checkboxes, selects and hidden fields), not typed in by the user.
  def answer_fields(html, ignored_fields)
    fragment = Nokogiri::HTML.fragment(html)
    fixed_value_types = %w[radio checkbox hidden]
    fields = fragment.css('input[name], textarea[name]').map do |node|
      fixed_value = node.name == 'input' && fixed_value_types.include?(node['type'])
      [node['name'], fixed_value ? node['value'] : nil]
    end
    fragment.css('select[name]').each do |select|
      select.css('option').each { |option| fields << [select['name'], option['value'] || option.text] }
    end
    fields.reject { |field| ignored_fields.include?(field.first) }
  end

  # en users still get the en "otherwise" label as the key of the default otherwise option (unchanged behaviour,
  # see QuestionTypeGenerator::RAW_OTHERWISE_LABEL_LOCALES). Map it to the nl key to compare the other fields.
  def with_nl_otherwise_keys(fields)
    en_label = I18n.t('questionnaires.placeholders.otherwise', locale: :en)
    nl_label = I18n.t('questionnaires.placeholders.otherwise', locale: :nl)
    en_key = en_label.parameterize.underscore
    nl_key = nl_label.parameterize.underscore
    fields.map do |name, value|
      [name.gsub(en_key, nl_key), value == en_label ? nl_label : value&.gsub(en_key, nl_key)]
    end
  end

  def expect_fully_translated(html, label)
    expect(html).not_to match(/translation[ _]missing/i), "#{label} has missing translations"
    # A text that was not translated shows up as an inspected hash, e.g. {nl: "...", en: "..."}.
    expect(html).not_to match(/\{(nl:|:nl\s*=>|"nl"\s*=>)/), "#{label} has an untranslated text"
  end

  projects = Rails.root.glob('projects/*/seeds/questionnaires').map { |dir| dir.parent.parent.basename.to_s }

  projects.each do |project|
    it "renders the questionnaires of #{project} in every locale with the same answer fields" do
      load_questionnaire_seeds(project)
      questionnaires = Questionnaire.all.to_a
      # Some projects only have commented out example seeds.
      skip "#{project} has no questionnaire seeds" if questionnaires.empty?

      aggregate_failures do
        questionnaires.each do |questionnaire|
          response = FactoryBot.create(:response, measurement: FactoryBot.create(:measurement,
                                                                                 questionnaire: questionnaire))
          renders = locales.index_with do |locale|
            render_questionnaire(response, locale).tap do |html|
              expect_fully_translated(html, "#{questionnaire.key} (#{locale})")
            end
          end
          nl_fields = answer_fields(renders['nl'], ignored_fields)
          expect(nl_fields).not_to be_empty if questionnaire.content[:questions].any? { |question| question[:id] }

          fallback_locales.each do |locale|
            expect(answer_fields(renders[locale], ignored_fields)).to(
              eq(nl_fields), "#{questionnaire.key} (#{locale}) differs from nl"
            )
          end
          expect(with_nl_otherwise_keys(answer_fields(renders['en'], ignored_fields))).to(
            eq(nl_fields), "#{questionnaire.key} (en) differs from nl"
          )
        end
      end
    end
  end
end
