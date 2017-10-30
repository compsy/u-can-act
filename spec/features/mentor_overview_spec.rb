# frozen_string_literal: true

require 'rails_helper'

describe 'GET and POST /', type: :feature, js: true do
  let(:mentor) { FactoryGirl.create(:mentor) }
  let(:students) { FactoryGirl.create_list(:student, 4, :with_random_name) }
  let(:other_students) do
    FactoryGirl.create_list(:student, 4, :with_random_name)
  end
  let(:response_objects) do
    students.map do |student|
      prot_sub = FactoryGirl.create(:protocol_subscription,
                                    person: mentor,
                                    filling_out_for: student,
                                    start_date: 1.week.ago.at_beginning_of_day)
      FactoryGirl.create(:response,
                         protocol_subscription: prot_sub,
                         open_from: 1.hour.ago,
                         invited_state: Response::SENT_STATE)
    end
  end

  let(:invitation_tokens) do
    response_objects.map do |responseobj|
      FactoryGirl.create(:invitation_token,
                         response: responseobj)
    end
  end

  it 'should redirect to the mentor overview page given any of the provided invitation tokens' do
    response_objects.each do |responseobj|
      expect(responseobj.completed_at).to be_nil
      expect(responseobj.content).to be_nil
      expect(responseobj.values).to be_nil
      expect(responseobj.opened_at).to be_nil
    end

    invitation_tokens.each do |inv_tok|
      visit "/?q=#{inv_tok.token}"

      # Check whether the correct redirect was performed
      expect(page).to_not have_current_path(questionnaire_path(q: inv_tok.token))
      expect(page).to have_current_path(mentor_overview_index_path)
    end
  end

  it 'should show the disclaimer link on the mentor overview page' do
    visit "/?q=#{invitation_tokens.first.token}"
    expect(page).to have_link('Disclaimer', href: '/disclaimer')
  end

  it 'should list the students of the current mentor on the page with the corresponding questionnaire links' do
    visit "/?q=#{invitation_tokens.first.token}"
    expect(page).to have_link('Vragenlijst invullen voor deze student', count: students.length)

    students.each do |student|
      expect(page).to have_content(student.first_name)
      expect(page).to have_content(student.last_name)
      token = mentor.protocol_subscriptions.where(filling_out_for_id: student.id)
                    .first.responses.first.invitation_token.token

      expect(page).to have_link(href: questionnaire_path(q: token))
    end

    other_students.each do |student|
      expect(page).to_not have_content(student.first_name)
      expect(page).to_not have_content(student.last_name)
    end
  end

  it 'should be possible to fillout a questionnaire for each of the mentors students' do
    visit "/?q=#{invitation_tokens.first.token}"
    students.each_with_index do |student, index|
      expect(page).to have_link('Vragenlijst invullen voor deze student', count: students.length - index)
      token = mentor.protocol_subscriptions.where(filling_out_for_id: student.id)
                    .first.responses.first.invitation_token.token

      page.find(:css, "a[href='#{questionnaire_path(q: token)}']").click
      expect(page).to have_current_path(questionnaire_path(q: token))

      # This is the informed consent
      page.click_on 'Opslaan'
      page.choose('slecht', allow_label_click: true)
      page.check('brood', allow_label_click: true)
      page.check('kaas en ham', allow_label_click: true)
      range_select('v3', '57')
      page.click_on 'Opslaan'
    end
    expect(page).to_not have_link('Vragenlijst invullen voor deze student')
  end

  it 'should be able to follow the initial link if one questionnaire has been filled out ' do
    token = invitation_tokens.first.token
    visit "/?q=#{token}"
    expect(page).to have_link('Vragenlijst invullen voor deze student', count: students.length)

    page.find(:css, "a[href='#{questionnaire_path(q: token)}']").click
    expect(page).to have_current_path(questionnaire_path(q: token))

    page.click_on 'Opslaan'
    page.choose('slecht', allow_label_click: true)
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    range_select('v3', '57')
    page.click_on 'Opslaan'

    visit "/?q=#{token}"
    expect(page).to have_link('Vragenlijst invullen voor deze student', count: students.length - 1)
  end
end
