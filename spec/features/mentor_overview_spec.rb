# frozen_string_literal: true

require 'rails_helper'

describe 'GET and POST /', type: :feature, js: true do
  let(:mentor) { FactoryBot.create(:mentor) }
  let(:students) { FactoryBot.create_list(:student, 4, :with_random_name) }
  let(:other_students) do
    FactoryBot.create_list(:student, 4, :with_random_name)
  end
  let(:response_objects) do
    students.map do |student|
      prot_sub = FactoryBot.create(:protocol_subscription,
                                   person: mentor,
                                   filling_out_for: student,
                                   start_date: 1.week.ago.at_beginning_of_day)
      FactoryBot.create(:response, :invited,
                        protocol_subscription: prot_sub,
                        open_from: 1.hour.ago)
    end
  end

  let(:invitation_tokens) do
    response_objects.map do |responseobj|
      FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    end
  end

  it 'redirects to the mentor overview page given any of the provided invitation tokens' do
    response_objects.each do |responseobj|
      expect(responseobj.completed_at).to be_nil
      expect(responseobj.content).to be_nil
      expect(responseobj.values).to be_nil
      expect(responseobj.opened_at).to be_nil
    end

    invitation_tokens.each do |inv_tok|
      visit inv_tok.invitation_set.invitation_url(inv_tok.token_plain, false)

      # Check whether the correct redirect was performed
      expect(page).not_to have_current_path(questionnaire_path(uuid: inv_tok.invitation_set.responses.first.uuid))
      expect(page).to have_current_path(mentor_overview_index_path)
    end
  end

  it 'shows the disclaimer link on the mentor overview page' do
    inv_tok = invitation_tokens.first
    visit "?q=#{inv_tok.invitation_set.person.external_identifier}#{inv_tok.token_plain}"
    expect(page).to have_link('Disclaimer', href: '/disclaimer')
  end

  it 'does not show the Gegevens aanpassen link on the mentor overview page' do
    inv_tok = invitation_tokens.first
    visit "?q=#{inv_tok.invitation_set.person.external_identifier}#{inv_tok.token_plain}"
    expect(page).not_to have_link('Gegevens aanpassen', href: '/person/edit')
  end

  it 'lists the students of the current mentor on the page with the corresponding questionnaire links' do
    inv_tok = invitation_tokens.first
    visit "?q=#{inv_tok.invitation_set.person.external_identifier}#{inv_tok.token_plain}"
    expect(page).to have_link('Vragenlijst invullen voor deze student', count: students.length)

    students.each do |student|
      expect(page).to have_content(student.first_name)
      expect(page).to have_content(student.last_name)
      uuid = mentor.protocol_subscriptions.where(filling_out_for_id: student.id)
                   .first.responses.first.uuid
      token = mentor.protocol_subscriptions.where(filling_out_for_id: student.id)
                    .first.responses.first.invitation_set.invitation_tokens.first.token

      expect(page).to have_link(href: questionnaire_path(uuid: uuid))
      expect(page).not_to have_content(token)
    end

    other_students.each do |student|
      expect(page).not_to have_content(student.first_name)
      expect(page).not_to have_content(student.last_name)
    end
  end

  it 'is possible to fill out a questionnaire for each of the mentors students' do
    inv_tok = invitation_tokens.first
    url = "?q=#{inv_tok.invitation_set.person.external_identifier}#{inv_tok.token_plain}"
    visit url
    students.each_with_index do |student, index|
      expect(page).to have_link('Vragenlijst invullen voor deze student', count: students.length - index)
      uuid = mentor.protocol_subscriptions.where(filling_out_for_id: student.id)
                   .first.responses.first.uuid

      page.find(:css, "a[href='#{questionnaire_path(uuid: uuid)}']").click
      expect(page).to have_current_path(questionnaire_path(uuid: uuid))

      # This is the informed consent
      page.click_on 'Opslaan'
      sleep(1)
      page.choose('slecht', allow_label_click: true)
      sleep(1)
      page.check('brood', allow_label_click: true)
      page.check('kaas en ham', allow_label_click: true)
      range_select('v3', '57')
      page.click_on 'Opslaan'
    end
    expect(page).not_to have_link('Vragenlijst invullen voor deze student')
  end

  it 'is possible to redirect to a response if the first one in the invitation set was filled out' do
    prot_sub = FactoryBot.create(:protocol_subscription,
                                 person: students.first,
                                 start_date: 1.week.ago.at_beginning_of_day)
    response_obj = FactoryBot.create(:response, :invited,
                                     protocol_subscription: prot_sub,
                                     open_from: 1.hour.ago)
    inv_tok = FactoryBot.create(:invitation_token, invitation_set: response_obj.invitation_set)
    response_obj2 = FactoryBot.create(:response,
                                      protocol_subscription: prot_sub,
                                      invitation_set: response_obj.invitation_set,
                                      open_from: 1.hour.ago)
    url = "?q=#{inv_tok.invitation_set.person.external_identifier}#{inv_tok.token_plain}"
    visit url
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    uuid = response_obj.uuid
    expect(page).to have_current_path(questionnaire_path(uuid: uuid))

    # This is the informed consent
    page.click_on 'Opslaan'
    sleep(1)
    page.choose('slecht', allow_label_click: true)
    sleep(1)
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    range_select('v3', '57')
    page.click_on 'Opslaan'

    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    uuid = response_obj2.uuid
    expect(page).to have_current_path(questionnaire_path(uuid: uuid))
    visit url
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    expect(page).to have_current_path(questionnaire_path(uuid: uuid))
  end

  it 'is able to follow the initial link if one questionnaire has been filled out' do
    inv_tok = invitation_tokens.first
    visit "?q=#{inv_tok.invitation_set.person.external_identifier}#{inv_tok.token_plain}"
    expect(page).to have_link('Vragenlijst invullen voor deze student', count: students.length)

    uuid = inv_tok.invitation_set.responses.first.uuid
    page.find(:css, "a[href='#{questionnaire_path(uuid: uuid)}']").click
    expect(page).to have_current_path(questionnaire_path(uuid: uuid))

    page.click_on 'Opslaan'
    sleep(1)
    page.choose('slecht', allow_label_click: true)
    sleep(1)
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    range_select('v3', '57')
    page.click_on 'Opslaan'

    visit "?q=#{inv_tok.invitation_set.person.external_identifier}#{inv_tok.token_plain}"
    expect(page).to have_link('Vragenlijst invullen voor deze student', count: students.length - 1)
  end
end
