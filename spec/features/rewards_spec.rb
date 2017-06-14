# frozen_string_literal: true

require 'rails_helper'

describe 'GET /klaar', type: :feature, js: true do
  it 'should be redirected after a questionnaire to the rewards page' do
    protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    FactoryGirl.create(:response,
                       protocol_subscription: protocol_subscription,
                       open_from: 1.day.ago,
                       invited_state: Response::NOT_SENT_STATE)
    FactoryGirl.create(:response, :completed,
                       protocol_subscription: protocol_subscription,
                       open_from: 2.days.ago)
    expect(protocol_subscription.reward_points).to eq 10
    expect(protocol_subscription.possible_reward_points).to eq 20
    expect(protocol_subscription.max_reward_points).to eq 30
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    visit "/questionnaire/#{invitation_token.token}"
    expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    # v1
    page.choose('slecht', allow_label_click: true)
    # v2
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    # v3
    range_select('v3', '57')
    page.click_on 'Opslaan'
    expect(page).to have_http_status(200)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    protocol_subscription.reload
    expect(protocol_subscription.reward_points).to eq 20
    expect(protocol_subscription.possible_reward_points).to eq 20
    expect(protocol_subscription.max_reward_points).to eq 30
    expect(page).to have_content('Je hebt hiermee 10 punten verdiend. Je hebt nu in totaal 20 punten')
    expect(page).to have_content('Het onderzoek is voor 67% voltooid. Er zijn nog 10 punten te verdienen.')
  end

  it 'should be redirected after a questionnaire to the rewards page from tokenauth controller' do
    protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    FactoryGirl.create(:response,
                       protocol_subscription: protocol_subscription,
                       open_from: 1.day.ago,
                       invited_state: Response::NOT_SENT_STATE)
    FactoryGirl.create(:response, :completed,
                       protocol_subscription: protocol_subscription,
                       open_from: 2.days.ago)
    expect(protocol_subscription.reward_points).to eq 10
    expect(protocol_subscription.possible_reward_points).to eq 20
    expect(protocol_subscription.max_reward_points).to eq 30
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    visit "/?q=#{invitation_token.token}"
    expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    # v1
    page.choose('slecht', allow_label_click: true)
    # v2
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    # v3
    range_select('v3', '57')
    page.click_on 'Opslaan'
    expect(page).to have_http_status(200)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    protocol_subscription.reload
    expect(protocol_subscription.reward_points).to eq 20
    expect(protocol_subscription.possible_reward_points).to eq 20
    expect(protocol_subscription.max_reward_points).to eq 30
    expect(page).to have_content('Je hebt hiermee 10 punten verdiend. Je hebt nu in totaal 20 punten')
    expect(page).to have_content('Het onderzoek is voor 67% voltooid. Er zijn nog 10 punten te verdienen.')
  end

  it 'should not show rewards for Mentors' do
    person = FactoryGirl.create(:mentor)
    protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                               start_date: 1.week.ago.at_beginning_of_day,
                                               person: person)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    FactoryGirl.create(:response,
                       protocol_subscription: protocol_subscription,
                       open_from: 1.day.ago,
                       invited_state: Response::NOT_SENT_STATE)
    FactoryGirl.create(:response, :completed,
                       protocol_subscription: protocol_subscription,
                       open_from: 2.days.ago)
    expect(protocol_subscription.reward_points).to eq 10
    expect(protocol_subscription.possible_reward_points).to eq 20
    expect(protocol_subscription.max_reward_points).to eq 30
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    visit "/questionnaire/#{invitation_token.token}"
    expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    # v1
    page.choose('slecht', allow_label_click: true)
    # v2
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    # v3
    range_select('v3', '57')
    page.click_on 'Opslaan'
    expect(page).to have_http_status(200)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    protocol_subscription.reload
    expect(protocol_subscription.reward_points).to eq 20
    expect(protocol_subscription.possible_reward_points).to eq 20
    expect(protocol_subscription.max_reward_points).to eq 30
    expect(page).not_to have_content('Je hebt hiermee 10 punten verdiend. Je hebt nu in totaal 20 punten')
    expect(page).not_to have_content('Je hebt nu in totaal')
    expect(page).not_to have_content('punten')
    expect(page).not_to have_content('Het onderzoek is voor 67% voltooid. Er zijn nog 10 punten te verdienen.')
  end

  it 'should not show rewards for Mentors from tokenauth controller' do
    person = FactoryGirl.create(:mentor)
    protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                               start_date: 1.week.ago.at_beginning_of_day,
                                               person: person)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    FactoryGirl.create(:response,
                       protocol_subscription: protocol_subscription,
                       open_from: 1.day.ago,
                       invited_state: Response::NOT_SENT_STATE)
    FactoryGirl.create(:response, :completed,
                       protocol_subscription: protocol_subscription,
                       open_from: 2.days.ago)
    expect(protocol_subscription.reward_points).to eq 10
    expect(protocol_subscription.possible_reward_points).to eq 20
    expect(protocol_subscription.max_reward_points).to eq 30
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    visit "/?q=#{invitation_token.token}"
    expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    # v1
    page.choose('slecht', allow_label_click: true)
    # v2
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    # v3
    range_select('v3', '57')
    page.click_on 'Opslaan'
    expect(page).to have_http_status(200)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    protocol_subscription.reload
    expect(protocol_subscription.reward_points).to eq 20
    expect(protocol_subscription.possible_reward_points).to eq 20
    expect(protocol_subscription.max_reward_points).to eq 30
    expect(page).not_to have_content('Je hebt hiermee 10 punten verdiend. Je hebt nu in totaal 20 punten')
    expect(page).not_to have_content('Je hebt nu in totaal')
    expect(page).not_to have_content('punten')
    expect(page).not_to have_content('Het onderzoek is voor 67% voltooid. Er zijn nog 10 punten te verdienen.')
  end
end
