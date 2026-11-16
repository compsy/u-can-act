# frozen_string_literal: true

require 'rails_helper'

# Regression check for N-language questionnaire support: existing questionnaires of other projects can be filled out
# by nl, en and fi users, and the answers are stored with the same (Dutch) keys and values for every locale.
describe 'filling out existing questionnaires in other locales', type: :feature do
  # A single-language (Dutch) questionnaire with most question types, and a questionnaire with nl/en texts.
  let(:demo_seed) { Rails.root.join('projects/demo/seeds/questionnaires/demo.rb') }
  let(:umo_seed) { Rails.root.join('projects/umo/seeds/questionnaires/01_demographics.rb') }
  let(:otherwise_keys) do
    %i[nl en].map { |locale| I18n.t('questionnaires.placeholders.otherwise', locale: locale).parameterize.underscore }
  end

  def open_questionnaire(questionnaire_key, locale)
    Capybara.reset_sessions!
    person = FactoryBot.create(:student, locale: locale)
    protocol_subscription = FactoryBot.create(:protocol_subscription, person: person,
                                                                      start_date: 1.week.ago.at_beginning_of_day)
    measurement = FactoryBot.create(:measurement, questionnaire: Questionnaire.find_by!(key: questionnaire_key))
    response = FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription,
                                                      open_from: 1.hour.ago, measurement: measurement)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: response.invitation_set)
    visit response.invitation_set.invitation_url(invitation_token.token_plain, false)
    expect(page).to have_current_path(questionnaire_path(uuid: response.uuid))
    response
  end

  # Picks the first option of every radio group, checks every checkbox and fills in every text field, skipping the
  # "otherwise" options. Selects (dropdowns, times) keep their default option.
  def answer_everything
    answerable_inputs('input[type=radio]').group_by { |input| input[:name] }
                                          .each_value { |inputs| inputs.first.set(true) }
    answerable_inputs('input[type=checkbox]').each { |input| input.set(true) }
    answerable_inputs('input[type=text], input[type=number], textarea').each do |input|
      input.set(input[:type] == 'number' ? '3' : 'tekst')
    end
  end

  def answerable_inputs(selector)
    page.all(selector).reject { |input| otherwise?(input) }
  end

  def otherwise?(input)
    otherwise_keys.any? { |key| input[:id].to_s.include?(key) }
  end

  def fill_out(questionnaire_key, locale)
    response = open_questionnaire(questionnaire_key, locale)
    answer_everything
    page.find('button[type=submit]').click
    response.reload
    expect(response.completed_at).to be_present
    response.values
  end

  it 'stores the same values for a single-language questionnaire in every locale' do
    load demo_seed
    values = %w[nl en fi].index_with { |locale| fill_out('demo', locale) }

    expect(values['nl']).to include('locale' => 'nl', 'v1' => 'Ja', 'v7_antwoord_1' => 'true', 'v5' => 'tekst')
    expect(values['en'].except('locale')).to eq(values['nl'].except('locale'))
    expect(values['fi'].except('locale')).to eq(values['nl'].except('locale'))
  end

  it 'shows the Dutch texts of a single-language questionnaire to fi users' do
    load demo_seed
    open_questionnaire('demo', 'fi')
    expect(page).to have_content('Voorbeeld van een radio')
    expect(page).to have_button('Tallenna')
  end

  it 'stores the Dutch values for a questionnaire with nl and en texts in every locale' do
    load umo_seed
    values = %w[nl en fi].index_with { |locale| fill_out('01_demographics', locale) }

    expect(values['nl']).to include('locale' => 'nl', 'v1' => 'tekst', 'v2' => 'Man')
    expect(values['en'].except('locale')).to eq(values['nl'].except('locale'))
    expect(values['fi'].except('locale')).to eq(values['nl'].except('locale'))
  end

  it 'shows the en texts of a questionnaire with nl and en texts to fi users' do
    load umo_seed
    open_questionnaire('01_demographics', 'fi')
    expect(page).to have_content('What is your gender identity?')
    expect(page).not_to have_content('Wat is uw geslacht?')
    expect(page).to have_button('Tallenna')
  end
end
