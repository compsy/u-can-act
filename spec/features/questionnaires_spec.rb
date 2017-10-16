# frozen_string_literal: true

require 'rails_helper'

describe 'GET and POST /', type: :feature, js: true do
  let(:student) { FactoryGirl.create(:student) }
  it 'should show and store a questionnaire successfully' do
    protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                               person: student,
                                               start_date: 1.week.ago.at_beginning_of_day)
    questionnaire = FactoryGirl.create(:questionnaire, content: [{
                                         section_start: 'Algemeen',
                                         id: :v1,
                                         type: :radio,
                                         title: 'Hoe voelt u zich vandaag?',
                                         options: %w[slecht goed],
                                         otherwise_label: 'Anders nog wat:'
                                       }, {
                                         id: :v2,
                                         type: :checkbox,
                                         title: 'Wat heeft u vandaag gegeten?',
                                         options: ['brood', 'kaas en ham', 'pizza'],
                                         otherwise_label: 'Hier ook iets:'
                                       }, {
                                         id: :v3,
                                         type: :range,
                                         title: 'Hoe gaat het met u?',
                                         labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens'],
                                         section_end: true
                                       }])
    measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE,
                                     measurement: measurement)
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    expect(responseobj.completed_at).to be_nil
    expect(responseobj.content).to be_nil
    expect(responseobj.values).to be_nil
    expect(responseobj.opened_at).to be_nil
    visit "/?q=#{invitation_token.token}"

    # Check whether the correct redirect was performed
    expect(page).to have_current_path(questionnaire_path(q: invitation_token.token))
    expect(page).to_not have_current_path(mentor_overview_index_path)
    responseobj.reload
    expect(responseobj.opened_at).to be_within(1.minute).of(Time.zone.now)
    # expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    expect(page).to have_content('Algemeen')
    # v1
    expect(page).to have_content('Hoe voelt u zich vandaag?')
    expect(page).to have_content('slecht')
    expect(page).to have_content('goed')
    expect(page).to have_content('Anders nog wat:')
    page.choose('slecht', allow_label_click: true)
    # v2
    expect(page).to have_content('Wat heeft u vandaag gegeten?')
    expect(page).to have_content('brood')
    expect(page).to have_content('kaas en ham')
    expect(page).to have_content('pizza')
    expect(page).to have_content('Hier ook iets:')
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    # v3
    expect(page).to have_content('Hoe gaat het met u?')
    expect(page).to have_content('niet mee eens')
    expect(page).to have_content('beetje mee eens')
    expect(page).to have_content('helemaal mee eens')
    range_select('v3', '57')
    page.click_on 'Opslaan'
    # expect(page).to have_http_status(200)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    responseobj.reload
    expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
    expect(responseobj.content).to_not be_nil
    expect(responseobj.values).to include('v1' => 'slecht',
                                          'v2_brood' => 'true',
                                          'v2_kaas_en_ham' => 'true',
                                          'v3' => '57')
  end

  it 'should store the results from the otherwise option for checkboxes and radios' do
    protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                               person: student,
                                               start_date: 1.week.ago.at_beginning_of_day)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    visit "/?q=#{invitation_token.token}"
    expect(page).to have_current_path(questionnaire_path(q: invitation_token.token))
    expect(page).to_not have_current_path(mentor_overview_index_path)
    # expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    # v1
    page.choose('v1_anders_namelijk', allow_label_click: true)
    page.fill_in('v1_anders_namelijk_text', with: 'of niet soms')
    # v2
    page.check('v2_anders_namelijk', allow_label_click: true)
    page.fill_in('v2_anders_namelijk_text', with: 'dit is een waarde')
    # v3
    page.click_on 'Opslaan'
    # expect(page).to have_http_status(200)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    responseobj.reload
    expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
    expect(responseobj.content).to_not be_nil
    expect(responseobj.values).to include('v1' => 'Anders, namelijk:',
                                          'v1_anders_namelijk_text' => 'of niet soms',
                                          'v2_anders_namelijk' => 'true',
                                          'v2_anders_namelijk_text' => 'dit is een waarde',
                                          'v3' => '50')
  end

  it 'should require radio buttons to be filled out' do
    protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                               start_date: 1.week.ago.at_beginning_of_day,
                                               person: student)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    visit "/?q=#{invitation_token.token}"
    # expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    # v1
    # Select nothing
    # v2
    page.check('v2_anders_namelijk', allow_label_click: true)
    page.fill_in('v2_anders_namelijk_text', with: 'dit is een waarde')
    # v3
    page.click_on 'Opslaan'
    # expect(page).to have_http_status(200)
    # The page didn't change because we didn't select a radio:
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
  end

  it 'should show an informed consent questionnaire' do
    protocol = FactoryGirl.create(:protocol, :with_informed_consent_questionnaire)
    expect(protocol.informed_consent_questionnaire).not_to be_nil
    expect(protocol.informed_consent_questionnaire.title).to eq 'Informed Consent'
    protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                               start_date: 1.week.ago.at_beginning_of_day,
                                               protocol: protocol,
                                               person: student)
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
    # expect(page).to have_http_status(200)
    expect(page).not_to have_content('vragenlijst-dagboekstudie-studenten')
    expect(page).to have_content('Informed Consent')
    expect(page).to have_content('Geef toestemming bla bla')
    expect(protocol_subscription.informed_consent_given_at).to be_nil
    expect(responseobj.opened_at).to be_nil
    page.click_on 'Volgende'
    # expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    responseobj.reload
    expect(responseobj.opened_at).to be_within(1.minute).of(Time.zone.now)
    protocol_subscription.reload
    expect(protocol_subscription.informed_consent_given_at).to be_within(1.minute).of(Time.zone.now)
    # v1
    page.choose('slecht', allow_label_click: true)
    # v2
    page.check('brood', allow_label_click: true)
    page.check('kaas en ham', allow_label_click: true)
    # v3
    range_select('v3', '57')
    page.click_on 'Opslaan'
    # expect(page).to have_http_status(200)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    responseobj.reload
    expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
    expect(responseobj.content).to_not be_nil
    expect(responseobj.values).to include('v1' => 'slecht',
                                          'v2_brood' => 'true',
                                          'v2_kaas_en_ham' => 'true',
                                          'v3' => '57')
  end

  it 'should not accept strings longer than the max' do
    protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                               start_date: 1.week.ago.at_beginning_of_day,
                                               person: student)
    responseobj = FactoryGirl.create(:response,
                                     protocol_subscription: protocol_subscription,
                                     open_from: 1.hour.ago,
                                     invited_state: Response::SENT_STATE)
    invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
    visit "/?q=#{invitation_token.token}"
    # expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    # v1
    page.choose('slecht', allow_label_click: true)
    # v2
    page.check('v2_anders_namelijk', allow_label_click: true)
    page.fill_in('v2_anders_namelijk_text', with: 'd' * (QuestionnaireController::MAX_ANSWER_LENGTH + 1))
    # v3
    page.click_on 'Opslaan'
    # expect(page).to have_http_status(200)
    # The page didn't change because an answe is too long
    expect(page).to have_content('Het antwoord is te lang en kan daardoor niet worden opgeslagen')
  end

  context 'shows and hides checkbox questions' do
    let(:content) do
      [{
        id: :v1,
        type: :radio,
        title: 'Hoe voelt u zich vandaag?',
        options: %w[slecht goed]
      }, {
        id: :v2,
        type: :checkbox,
        title: 'Wat heeft u vandaag gegeten?',
        options: [
          { title: 'brood', shows_questions: %i[v3] },
          'kaas en ham',
          { title: 'pizza', shows_questions: %i[v4 v5], tooltip: 'some text' }
        ]
      }, {
        section_start: 'My hidden question',
        id: :v3,
        hidden: true,
        type: :range,
        title: 'Zie je mij of niet?',
        labels: ['helemaal niet', 'helemaal wel']
      }, {
        id: :v4,
        hidden: true,
        type: :checkbox,
        title: 'Ben ik ook onzichtbaar?',
        options: ['antwoord a', 'antwoord b']
      }, {
        id: :v5,
        hidden: true,
        type: :radio,
        title: 'Zie je mij?',
        options: %w[Hihaho hahaha],
        section_end: true
      }]
    end

    it 'shows and hides questions' do
      protocol = FactoryGirl.create(:protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 protocol: protocol,
                                                 person: student)
      questionnaire = FactoryGirl.create(:questionnaire, content: content)
      measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryGirl.create(:response,
                                       protocol_subscription: protocol_subscription,
                                       measurement: measurement,
                                       open_from: 1.hour.ago,
                                       invited_state: Response::SENT_STATE)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      visit "/?q=#{invitation_token.token}"
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_content('Hoe voelt u zich vandaag?')
      expect(page).to have_content('slecht')
      expect(page).to have_content('goed')
      expect(page).to have_content('Wat heeft u vandaag gegeten?')
      expect(page).to have_content('brood')
      expect(page).to have_content('kaas en ham')
      expect(page).to have_content('pizza')

      expect(page).to have_css('h5', text: 'My hidden question', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: false)
      expect(page).to have_css('div', text: 'helemaal niet', visible: false)
      expect(page).to have_css('div', text: 'helemaal wel', visible: false)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: false)
      expect(page).to have_css('label', text: 'antwoord a', visible: false)
      expect(page).to have_css('label', text: 'antwoord b', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: false)
      expect(page).to have_css('label', text: 'Hihaho', visible: false)
      expect(page).to have_css('label', text: 'hahaha', visible: false)
      # v1
      page.choose('slecht', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: false)
      expect(page).to have_css('div', text: 'helemaal niet', visible: false)
      expect(page).to have_css('div', text: 'helemaal wel', visible: false)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: false)
      expect(page).to have_css('label', text: 'antwoord a', visible: false)
      expect(page).to have_css('label', text: 'antwoord b', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: false)
      expect(page).to have_css('label', text: 'Hihaho', visible: false)
      expect(page).to have_css('label', text: 'hahaha', visible: false)
      # v2
      page.check('brood', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: true)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: true)
      expect(page).to have_css('div', text: 'helemaal niet', visible: true)
      expect(page).to have_css('div', text: 'helemaal wel', visible: true)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: false)
      expect(page).to have_css('label', text: 'antwoord a', visible: false)
      expect(page).to have_css('label', text: 'antwoord b', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: false)
      expect(page).to have_css('label', text: 'Hihaho', visible: false)
      expect(page).to have_css('label', text: 'hahaha', visible: false)
      # v2
      page.check('pizza', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: true)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: true)
      expect(page).to have_css('div', text: 'helemaal niet', visible: true)
      expect(page).to have_css('div', text: 'helemaal wel', visible: true)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: true)
      expect(page).to have_css('label', text: 'antwoord a', visible: true)
      expect(page).to have_css('label', text: 'antwoord b', visible: true)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: true)
      expect(page).to have_css('label', text: 'Hihaho', visible: true)
      expect(page).to have_css('label', text: 'hahaha', visible: true)
      page.uncheck('pizza', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: true)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: true)
      expect(page).to have_css('div', text: 'helemaal niet', visible: true)
      expect(page).to have_css('div', text: 'helemaal wel', visible: true)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: false)
      expect(page).to have_css('label', text: 'antwoord a', visible: false)
      expect(page).to have_css('label', text: 'antwoord b', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: false)
      expect(page).to have_css('label', text: 'Hihaho', visible: false)
      expect(page).to have_css('label', text: 'hahaha', visible: false)
      page.check('pizza', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: true)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: true)
      expect(page).to have_css('div', text: 'helemaal niet', visible: true)
      expect(page).to have_css('div', text: 'helemaal wel', visible: true)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: true)
      expect(page).to have_css('label', text: 'antwoord a', visible: true)
      expect(page).to have_css('label', text: 'antwoord b', visible: true)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: true)
      expect(page).to have_css('label', text: 'Hihaho', visible: true)
      expect(page).to have_css('label', text: 'hahaha', visible: true)
      # v3
      range_select('v3', '64')
      # v4
      page.check('antwoord a', allow_label_click: true)
      # v5
      page.choose('hahaha', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).to_not be_nil
      expect(responseobj.values).to include('v1' => 'slecht',
                                            'v2_brood' => 'true',
                                            'v2_pizza' => 'true',
                                            'v3' => '64',
                                            'v4_antwoord_a' => 'true',
                                            'v5' => 'hahaha')
    end
    it 'should not prevent from sending invisible answers' do
      protocol = FactoryGirl.create(:protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 protocol: protocol,
                                                 person: student)
      questionnaire = FactoryGirl.create(:questionnaire, content: content)
      measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryGirl.create(:response,
                                       protocol_subscription: protocol_subscription,
                                       measurement: measurement,
                                       open_from: 1.hour.ago,
                                       invited_state: Response::SENT_STATE)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      visit "/?q=#{invitation_token.token}"
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      # The page didn't change because we didn't select a radio for v1:
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.choose('slecht', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).to_not be_nil
      expect(responseobj.values).to include('v1' => 'slecht')
    end
    it 'should require invisible radios once they become visible' do
      protocol = FactoryGirl.create(:protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 protocol: protocol,
                                                 person: student)
      questionnaire = FactoryGirl.create(:questionnaire, content: content)
      measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryGirl.create(:response,
                                       protocol_subscription: protocol_subscription,
                                       measurement: measurement,
                                       open_from: 1.hour.ago,
                                       invited_state: Response::SENT_STATE)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      visit "/?q=#{invitation_token.token}"
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.choose('slecht', allow_label_click: true)
      page.check('pizza', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      # The page didn't change because we didn't select a radio for v5:
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # expect(page).to have_http_status(200)
      # v5
      page.choose('Hihaho', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).to_not be_nil
      expect(responseobj.values).to include('v1' => 'slecht',
                                            'v2_pizza' => 'true',
                                            'v5' => 'Hihaho')
      expect(responseobj.values.keys).not_to include('v3')
    end
  end
  context 'shows and hides radio questions' do
    let(:content) do
      [{
        id: :v1,
        type: :checkbox,
        title: 'Hoe voelt u zich vandaag?',
        options: %w[slecht goed]
      }, {
        id: :v2,
        type: :radio,
        title: 'Wat heeft u vandaag gegeten?',
        options: [
          { title: 'brood', shows_questions: %i[v3] },
          'kaas en ham',
          { title: 'pizza', shows_questions: %i[v4 v5], tooltip: 'some text' }
        ]
      }, {
        section_start: 'My hidden question',
        id: :v3,
        hidden: true,
        type: :range,
        title: 'Zie je mij of niet?',
        labels: ['helemaal niet', 'helemaal wel']
      }, {
        id: :v4,
        hidden: true,
        type: :checkbox,
        title: 'Ben ik ook onzichtbaar?',
        options: ['antwoord a', 'antwoord b']
      }, {
        id: :v5,
        hidden: true,
        type: :radio,
        title: 'Zie je mij?',
        options: %w[Hihaho hahaha],
        section_end: true
      }]
    end

    it 'shows and hides questions' do
      protocol = FactoryGirl.create(:protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 protocol: protocol,
                                                 person: student)
      questionnaire = FactoryGirl.create(:questionnaire, content: content)
      measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryGirl.create(:response,
                                       protocol_subscription: protocol_subscription,
                                       measurement: measurement,
                                       open_from: 1.hour.ago,
                                       invited_state: Response::SENT_STATE)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      visit "/?q=#{invitation_token.token}"
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_content('Hoe voelt u zich vandaag?')
      expect(page).to have_content('slecht')
      expect(page).to have_content('goed')
      expect(page).to have_content('Wat heeft u vandaag gegeten?')
      expect(page).to have_content('brood')
      expect(page).to have_content('kaas en ham')
      expect(page).to have_content('pizza')

      expect(page).to have_css('h5', text: 'My hidden question', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: false)
      expect(page).to have_css('div', text: 'helemaal niet', visible: false)
      expect(page).to have_css('div', text: 'helemaal wel', visible: false)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: false)
      expect(page).to have_css('label', text: 'antwoord a', visible: false)
      expect(page).to have_css('label', text: 'antwoord b', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: false)
      expect(page).to have_css('label', text: 'Hihaho', visible: false)
      expect(page).to have_css('label', text: 'hahaha', visible: false)
      # v1
      page.check('slecht', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: false)
      expect(page).to have_css('div', text: 'helemaal niet', visible: false)
      expect(page).to have_css('div', text: 'helemaal wel', visible: false)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: false)
      expect(page).to have_css('label', text: 'antwoord a', visible: false)
      expect(page).to have_css('label', text: 'antwoord b', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: false)
      expect(page).to have_css('label', text: 'Hihaho', visible: false)
      expect(page).to have_css('label', text: 'hahaha', visible: false)
      # v2
      page.choose('brood', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: true)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: true)
      expect(page).to have_css('div', text: 'helemaal niet', visible: true)
      expect(page).to have_css('div', text: 'helemaal wel', visible: true)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: false)
      expect(page).to have_css('label', text: 'antwoord a', visible: false)
      expect(page).to have_css('label', text: 'antwoord b', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: false)
      expect(page).to have_css('label', text: 'Hihaho', visible: false)
      expect(page).to have_css('label', text: 'hahaha', visible: false)
      # v2
      page.choose('pizza', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: false)
      expect(page).to have_css('div', text: 'helemaal niet', visible: false)
      expect(page).to have_css('div', text: 'helemaal wel', visible: false)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: true)
      expect(page).to have_css('label', text: 'antwoord a', visible: true)
      expect(page).to have_css('label', text: 'antwoord b', visible: true)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: true)
      expect(page).to have_css('label', text: 'Hihaho', visible: true)
      expect(page).to have_css('label', text: 'hahaha', visible: true)
      page.choose('kaas en ham', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: false)
      expect(page).to have_css('div', text: 'helemaal niet', visible: false)
      expect(page).to have_css('div', text: 'helemaal wel', visible: false)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: false)
      expect(page).to have_css('label', text: 'antwoord a', visible: false)
      expect(page).to have_css('label', text: 'antwoord b', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: false)
      expect(page).to have_css('label', text: 'Hihaho', visible: false)
      expect(page).to have_css('label', text: 'hahaha', visible: false)
      page.choose('pizza', allow_label_click: true)
      expect(page).to have_css('h5', text: 'My hidden question', visible: false)
      expect(page).to have_css('p', text: 'Zie je mij of niet?', visible: false)
      expect(page).to have_css('div', text: 'helemaal niet', visible: false)
      expect(page).to have_css('div', text: 'helemaal wel', visible: false)
      expect(page).to have_css('p', text: 'Ben ik ook onzichtbaar?', visible: true)
      expect(page).to have_css('label', text: 'antwoord a', visible: true)
      expect(page).to have_css('label', text: 'antwoord b', visible: true)
      expect(page).to have_css('p', text: 'Zie je mij?', visible: true)
      expect(page).to have_css('label', text: 'Hihaho', visible: true)
      expect(page).to have_css('label', text: 'hahaha', visible: true)
      # v3
      range_select('v3', '64')
      # v4
      page.check('antwoord a', allow_label_click: true)
      # v5
      page.choose('hahaha', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).to_not be_nil
      expect(responseobj.values).to include('v1_slecht' => 'true',
                                            'v2' => 'pizza',
                                            'v4_antwoord_a' => 'true',
                                            'v5' => 'hahaha')
      expect(responseobj.values.keys).not_to include('v3')
    end
    it 'should not prevent from sending invisible answers' do
      protocol = FactoryGirl.create(:protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 protocol: protocol,
                                                 person: student)
      questionnaire = FactoryGirl.create(:questionnaire, content: content)
      measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryGirl.create(:response,
                                       protocol_subscription: protocol_subscription,
                                       measurement: measurement,
                                       open_from: 1.hour.ago,
                                       invited_state: Response::SENT_STATE)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      visit "/?q=#{invitation_token.token}"
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      # The page didn't change because we didn't select a radio for v2:
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v2
      page.choose('brood', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).to_not be_nil
      expect(responseobj.values).to include('v2' => 'brood')
      expect(responseobj.values.keys).to include('v3')
    end
    it 'should require invisible radios once they become visible' do
      protocol = FactoryGirl.create(:protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 protocol: protocol,
                                                 person: student)
      questionnaire = FactoryGirl.create(:questionnaire, content: content)
      measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryGirl.create(:response,
                                       protocol_subscription: protocol_subscription,
                                       measurement: measurement,
                                       open_from: 1.hour.ago,
                                       invited_state: Response::SENT_STATE)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      visit "/?q=#{invitation_token.token}"
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.check('goed', allow_label_click: true)
      page.choose('pizza', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      # The page didn't change because we didn't select a radio for v5:
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v5
      page.choose('Hihaho', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).to_not be_nil
      expect(responseobj.values).to include('v1_goed' => 'true',
                                            'v2' => 'pizza',
                                            'v5' => 'Hihaho')
      expect(responseobj.values.keys).not_to include('v3')
    end
  end

  context 'textarea' do
    let(:content) do
      [{
        id: :v1,
        type: :radio,
        title: 'Wat heeft u vandaag gegeten?',
        options: [
          { title: 'brood', shows_questions: %i[v2] },
          'pizza'
        ]
      }, {
        section_start: 'My hidden question',
        id: :v2,
        hidden: true,
        type: :textarea,
        title: 'Zie je mij of niet?',
        section_end: true
      }, {
        id: :v3,
        type: :textarea,
        title: 'Dit is je tekstruimte'
      }]
    end

    it 'should store the results from a textarea' do
      protocol = FactoryGirl.create(:protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 protocol: protocol,
                                                 person: student)
      questionnaire = FactoryGirl.create(:questionnaire, content: content)
      measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryGirl.create(:response,
                                       protocol_subscription: protocol_subscription,
                                       measurement: measurement,
                                       open_from: 1.hour.ago,
                                       invited_state: Response::SENT_STATE)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      visit "/?q=#{invitation_token.token}"
      expect(page).to have_current_path(questionnaire_path(q: invitation_token.token))
      expect(page).to_not have_current_path(mentor_overview_index_path)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.choose('pizza', allow_label_click: true)
      page.fill_in('v3', with: 'of niet soms')
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).to_not be_nil
      expect(responseobj.values).to include('v1' => 'pizza',
                                            'v3' => 'of niet soms')
    end
    it 'should require not require textareas to be filled out' do
      protocol = FactoryGirl.create(:protocol)
      protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                 start_date: 1.week.ago.at_beginning_of_day,
                                                 protocol: protocol,
                                                 person: student)
      questionnaire = FactoryGirl.create(:questionnaire, content: content)
      measurement = FactoryGirl.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryGirl.create(:response,
                                       protocol_subscription: protocol_subscription,
                                       measurement: measurement,
                                       open_from: 1.hour.ago,
                                       invited_state: Response::SENT_STATE)
      invitation_token = FactoryGirl.create(:invitation_token, response: responseobj)
      visit "/?q=#{invitation_token.token}"
      expect(page).to have_current_path(questionnaire_path(q: invitation_token.token))
      expect(page).to_not have_current_path(mentor_overview_index_path)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_css('label', text: 'Vul iets in', visible: false)
      expect(page).to have_css('p', text: 'Dit is je tekstruimte', visible: false)
      # v1
      page.choose('brood', allow_label_click: true)
      expect(page).to have_css('label', text: 'Vul iets in', visible: true)
      expect(page).to have_css('p', text: 'Dit is je tekstruimte', visible: true)
      # v3
      page.fill_in('v3', with: 'of niet soms')
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).to_not be_nil
      expect(responseobj.values).to include('v1' => 'brood',
                                            'v3' => 'of niet soms')
    end
  end
end
