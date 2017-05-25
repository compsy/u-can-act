# frozen_string_literal: true

require 'rails_helper'

describe 'GET and POST /', type: :feature, js: true do
  it 'should show and store a questionnaire successfully' do
    protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    expect(responseobj.completed_at).to be_nil
    expect(responseobj.content).to be_nil
    expect(responseobj.values).to be_nil
    expect(responseobj.opened_at).to be_nil
    visit "/?q=#{invitation_token.token}"
    responseobj.reload
    expect(responseobj.opened_at).to be_within(1.minute).of(Time.zone.now)
    expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    expect(page).to have_content('Algemeen')
    # v1
    expect(page).to have_content('Hoe voelt u zich vandaag?')
    expect(page).to have_content('slecht')
    expect(page).to have_content('goed')
    expect(page).to have_content('Anders, namelijk:')
    page.choose('slecht', allow_label_click: true)
    # v2
    expect(page).to have_content('Wat heeft u vandaag gegeten?')
    expect(page).to have_content('brood')
    expect(page).to have_content('kaas en ham')
    expect(page).to have_content('pizza')
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    # v3
    expect(page).to have_content('Hoe gaat het met u?')
    expect(page).to have_content('niet mee eens')
    expect(page).to have_content('beetje mee eens')
    expect(page).to have_content('helemaal mee eens')
    puts range_select('v3', '57')
    page.click_on 'Opslaan'
    expect(page).to have_http_status(200)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    responseobj.reload
    expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
    expect(responseobj.content).to_not be_nil
    expect(responseobj.values).to eq('v1' => 'slecht',
                                     'v2_brood' => 'true',
                                     'v2_kaas_en_ham' => 'true',
                                     'v3' => '57')
  end
  it 'should store the results from the otherwise option for checkboxes and radios' do
    protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    visit "/?q=#{invitation_token.token}"
    expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    # v1
    page.choose('v1_anders_namelijk', allow_label_click: true)
    page.fill_in('v1_anders_namelijk_text', with: 'of niet soms')
    # v2
    page.check('v2_anders_namelijk', allow_label_click: true)
    page.fill_in('v2_anders_namelijk_text', with: 'dit is een waarde')
    # v3
    page.click_on 'Opslaan'
    expect(page).to have_http_status(200)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    responseobj.reload
    expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
    expect(responseobj.content).to_not be_nil
    expect(responseobj.values).to eq('v1' => 'Anders, namelijk:',
                                     'v1_anders_namelijk_text' => 'of niet soms',
                                     'v2_anders_namelijk' => 'true',
                                     'v2_anders_namelijk_text' => 'dit is een waarde',
                                     'v3' => '50')
  end
  it 'should require radio buttons to be filled out' do
    protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    visit "/?q=#{invitation_token.token}"
    expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    # v1
    # Select nothing
    # v2
    page.check('v2_anders_namelijk', allow_label_click: true)
    page.fill_in('v2_anders_namelijk_text', with: 'dit is een waarde')
    # v3
    page.click_on 'Opslaan'
    expect(page).to have_http_status(200)
    # The page didn't change because we didn't select a radio:
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
  end
end
