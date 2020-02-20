# frozen_string_literal: true

require 'rails_helper'

describe 'SHOW /otr', type: :feature, js: true do
  it 'shows and a questionnaire successfully' do
    protocol = FactoryBot.create(:protocol)
    FactoryBot.create(
      :team,
      :with_roles,
      name: Rails.application.config.settings.default_team_name
    )
    questionnaire = FactoryBot.create(:questionnaire, content: { questions: [{
                                        section_start: 'Algemeen',
                                        id: :v1,
                                        type: :radio,
                                        title: 'Hoe voelt u zich vandaag?',
                                        options: %w[slecht goed],
                                        otherwise_label: 'Anders nog wat:'
                                      }], scores: [] })
    FactoryBot.create(
      :measurement,
      protocol: protocol,
      open_from_offset: 0,
      questionnaire: questionnaire
    )
    otr = OneTimeResponse.create(protocol: protocol)

    visit one_time_response_path(q: otr.token)
    responseobj = Person.last.my_open_one_time_responses.first
    expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
    responseobj.reload
    expect(responseobj.opened_at).to be_within(1.minute).of(Time.zone.now)
    expect(page).to have_content('Algemeen')
  end
end
