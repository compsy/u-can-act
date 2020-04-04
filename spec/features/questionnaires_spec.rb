# frozen_string_literal: true

require 'rails_helper'

describe 'GET and POST /', type: :feature, js: true do
  let(:person_header) { 'Accountgegevens bewerken' }
  let(:student) { FactoryBot.create(:student) }
  let(:mentor) { FactoryBot.create(:mentor, first_name: 'Dagobert') }

  it 'shows and store a questionnaire successfully' do
    protocol_subscription = FactoryBot.create(:protocol_subscription, person: student,
                                                                      start_date: 1.week.ago.at_beginning_of_day)

    questionnaire = FactoryBot.create(:questionnaire, content: { questions: [{
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
                                        labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens']
                                      }, {
                                        id: :v4,
                                        type: :time,
                                        title: 'Hoeveel tijd deed u over het eten?',
                                        hours_from: 1,
                                        hours_to: 10,
                                        hours_step: 1,
                                        section_end: true
                                      }], scores: [] })
    measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    open_from: 1.hour.ago,
                                    measurement: measurement)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    expect(responseobj.completed_at).to be_nil
    expect(responseobj.content).to be_nil
    expect(responseobj.values).to be_nil
    expect(responseobj.opened_at).to be_nil
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)

    # Check whether the correct redirect was performed
    expect(page).to have_current_path(questionnaire_path(uuid: invitation_token.invitation_set.responses.first.uuid))
    expect(page).not_to have_current_path(mentor_overview_index_path)
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

    # v4
    expect(page).to have_content('Hoeveel tijd deed u over het eten?')
    # materialize_select(1, 4, 'div.v4_uren>')
    normal_select('#v4_uren', 4)
    # materialize_select(0, 15, 'div.v4_minuten>')
    normal_select('#v4_minuten', 15)
    page.click_on 'Opslaan'
    # expect(page).to have_http_status(200)
    sleep(10)
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    responseobj.reload
    expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
    expect(responseobj.content).not_to be_nil
    expect(responseobj.values).to include('v1' => 'slecht',
                                          'v2_brood' => 'true',
                                          'v2_kaas_en_ham' => 'true',
                                          'v3' => '57',
                                          'v4_uren' => '4',
                                          'v4_minuten' => '15')
  end

  it 'respects the required attribute for a group of checkboxes' do
    content = { questions: [{
      id: :v1,
      type: :checkbox,
      required: true,
      title: 'Wat heeft u vandaag gegeten?',
      options: %w[brood pizza]
    }, {
      id: :v2,
      type: :checkbox,
      required: false,
      title: 'Hoe oud ben jij?',
      options: %w[12 13]
    }], scores: [] }
    protocol = FactoryBot.create(:protocol)
    protocol_subscription = FactoryBot.create(:protocol_subscription,
                                              start_date: 1.week.ago.at_beginning_of_day,
                                              protocol: protocol,
                                              person: student)
    questionnaire = FactoryBot.create(:questionnaire, content: content)
    measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    measurement: measurement,
                                    open_from: 1.hour.ago)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
    expect(page).to have_current_path(questionnaire_path(uuid: invitation_token.invitation_set.responses.first.uuid))
    expect(page).not_to have_current_path(mentor_overview_index_path)
    # expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    expect(page).to have_css('p', text: 'Wat heeft u vandaag gegeten?')
    page.click_on 'Opslaan'
    # expect(page).to have_http_status(200)
    expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
    responseobj.reload
    expect(responseobj.completed_at).to be_nil
    expect(responseobj.content).to be_nil
    page.check('pizza', allow_label_click: true)
    page.click_on 'Opslaan'
    expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
    responseobj.reload
    expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
    expect(responseobj.content).not_to be_nil
    expect(responseobj.values).to include('v1_pizza' => 'true')
    expect(responseobj.values.keys).not_to include('v2_12')
    expect(responseobj.values.keys).not_to include('v2_13')
    expect(responseobj.values.keys).not_to include('v2')
  end

  it 'stores the results from the otherwise option for checkboxes and radios' do
    protocol_subscription = FactoryBot.create(:protocol_subscription,
                                              person: student,
                                              start_date: 1.week.ago.at_beginning_of_day)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    open_from: 1.hour.ago)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
    expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
    expect(page).not_to have_current_path(mentor_overview_index_path)
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
    expect(responseobj.content).not_to be_nil
    expect(responseobj.values).to include('v1' => 'Anders, namelijk:',
                                          'v1_anders_namelijk_text' => 'of niet soms',
                                          'v2_anders_namelijk' => 'true',
                                          'v2_anders_namelijk_text' => 'dit is een waarde',
                                          'v3' => '50')
  end

  describe 'should store the results from the expandables' do
    it 'works with links_to_expandable' do
      content = { questions: [
        {
          id: :v1,
          type: :number,
          required: true,
          links_to_expandable: :v3,
          title: 'Hoeveel expansies?'
        }, {
          id: :v2,
          type: :checkbox,
          title: 'Of niet soms?',
          options: %w[Ja Nee]
        }, {
          id: :v3,
          title: 'Dit is expansies',
          type: :expandable,
          default_expansions: 0,
          max_expansions: 10,
          content: [
            {
              type: :raw,
              content: 'Hihaho'
            }
          ]
        }
      ], scores: [] }
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                person: student)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)

      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      # expect(page).to have_http_status(200)
      expect(page.has_text?(:visible, 'Hihaho')).to be_falsey

      # Required questions
      page.fill_in('v1', with: '1')
      page.check('Ja', allow_label_click: true)
      expect(page.has_text?(:visible, 'Hihaho')).to be_truthy
      page.fill_in('v1', with: '0')
      page.check('Nee', allow_label_click: true)
      expect(page.has_text?(:visible, 'Hihaho')).to be_falsey
    end

    it 'onlies store the one which is defaultly visible' do
      questionnaire = FactoryBot.create(:questionnaire, :one_expansion)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                person: student)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)

      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')

      # Required questions
      page.choose('slecht', allow_label_click: true)
      page.check('brood', allow_label_click: true)
      page.fill_in('v4_0_1', with: 'dit is een doel')

      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'slecht',
                                            'v2_brood' => 'true',
                                            'v3' => '50',
                                            'v4_0_1' => 'dit is een doel',
                                            'v4_0_5' => '50')
      expect(responseobj.values.values).not_to include('v4_0_4')

      not_allowed_keys = (1..10).map do |q_id|
        (1..5).map { |sub_q_id| "v4_#{q_id}_#{sub_q_id}" }
      end.flatten

      expect(responseobj.values.values).not_to include(not_allowed_keys)
    end

    describe 'should not store any V4s if none of them is visible' do
      it 'by default' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, :invited,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 1.hour.ago)
        invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
        visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
        expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
        expect(page).not_to have_current_path(mentor_overview_index_path)
        # expect(page).to have_http_status(200)
        expect(page).to have_content('vragenlijst-dagboekstudie-studenten')

        # Required questions
        page.choose('slecht', allow_label_click: true)
        page.check('brood', allow_label_click: true)

        page.click_on 'Opslaan'
        # expect(page).to have_http_status(200)
        expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
        responseobj.reload
        expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
        expect(responseobj.content).not_to be_nil
        expect(responseobj.values).to include('v1' => 'slecht',
                                              'v2_brood' => 'true',
                                              'v3' => '50')

        not_allowed_keys = (0..10).map do |q_id|
          (1..5).map { |sub_q_id| "v4_#{q_id}_#{sub_q_id}" }
        end.flatten

        expect(responseobj.values.values).not_to include(not_allowed_keys)
      end

      it 'after showing / hiding' do
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  person: student,
                                                  start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, :invited,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 1.hour.ago)
        invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
        visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
        expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
        expect(page).not_to have_current_path(mentor_overview_index_path)
        # expect(page).to have_http_status(200)
        expect(page).to have_content('vragenlijst-dagboekstudie-studenten')

        # Required questions
        page.choose('slecht', allow_label_click: true)
        page.check('brood', allow_label_click: true)

        remove = page.find('a', text: 'Verwijder doel')
        add = page.find('a', text: 'Voeg doel toe')
        10.times { |_x| add.click }
        10.times { |_x| remove.click }

        page.click_on 'Opslaan'
        # expect(page).to have_http_status(200)
        expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
        responseobj.reload
        expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
        expect(responseobj.content).not_to be_nil
        expect(responseobj.values).to include('v1' => 'slecht',
                                              'v2_brood' => 'true',
                                              'v3' => '50')

        not_allowed_keys = (0..10).map do |q_id|
          (1..5).map { |sub_q_id| "v4_#{q_id}_#{sub_q_id}" }
        end.flatten

        expect(responseobj.values.values).not_to include(not_allowed_keys)
      end
    end
  end

  it 'onlies have disabled questions (for the expandables) whenever the default expansion is 0' do
    protocol_subscription = FactoryBot.create(:protocol_subscription,
                                              person: student,
                                              start_date: 1.week.ago.at_beginning_of_day)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    open_from: 1.hour.ago)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
    # expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')

    # v4
    expect(page).to have_css('a', text: 'Voeg doel toe')
    expect(page).not_to have_css('a', text: '+')
    expect(page).to have_css('a', text: 'Verwijder doel')
    expect(page).not_to have_css('a', text: '-')

    # All hidden question options should be disabled
    (0..10).each do |q_id|
      (1..5).each do |sub_q_id|
        id = "v4_#{q_id}_#{sub_q_id}"
        result = page.all("textarea[id^=#{id}],input[id^=#{id}]")
        all_disabled_and_hidden = result.all? { |elem| elem.disabled? && !elem.visible? }
        expect(all_disabled_and_hidden).to be_truthy
      end
    end
  end

  it 'onlies have exactly 1 non-disabled question (for the expandables) whenever the default expansion is 1' do
    questionnaire = FactoryBot.create(:questionnaire, :one_expansion)
    measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
    protocol_subscription = FactoryBot.create(:protocol_subscription,
                                              start_date: 1.week.ago.at_beginning_of_day,
                                              person: student)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    measurement: measurement,
                                    open_from: 1.hour.ago)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
    # expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')

    # v4
    expect(page).to have_css('a', text: 'Voeg doel toe')
    expect(page).not_to have_css('a', text: '+')
    expect(page).to have_css('a', text: 'Verwijder doel')
    expect(page).not_to have_css('a', text: '-')

    # first questions should not be disabled
    question_id = 0
    (1..5).each do |sub_q_id|
      id = "v4_#{question_id}_#{sub_q_id}"
      result = page.all("textarea[id^=#{id}],input[id^=#{id}]")
      all_not_disabled = result.none? do |elem|
        # Skip the 'anders namelijk field, it is allowed to be disabled'
        anders_namelijk_field = "#{id}_anders_namelijk_text"
        elem.disabled? && !anders_namelijk_field
      end
      expect(all_not_disabled).to be_truthy
    end

    # All other, hidden question options should be disabled
    (1..10).each do |q_id|
      (1..5).each do |sub_q_id|
        id = "v4_#{q_id}_#{sub_q_id}"
        result = page.all("textarea[id^=#{id}],input[id^=#{id}]")
        all_disabled_and_hidden = result.all? { |elem| elem.disabled? && !elem.visible? }
        expect(all_disabled_and_hidden).to be_truthy
      end
    end
  end

  it 'has the correct buttons for the expandables' do
    questionnaire = FactoryBot.create(:questionnaire, :one_expansion)
    measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
    protocol_subscription = FactoryBot.create(:protocol_subscription,
                                              start_date: 1.week.ago.at_beginning_of_day,
                                              person: student)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    measurement: measurement,
                                    open_from: 1.hour.ago)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
    # expect(page).to have_http_status(200)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')

    # v4
    expect(page).to have_css('a', text: 'Voeg doel toe')
    expect(page).to have_css('a', text: 'Verwijder doel')

    add = page.find('a', text: 'Voeg doel toe')
    remove = page.find('a', text: 'Verwijder doel')

    expect(add[:class]).not_to include('disabled')
    expect(remove[:class]).not_to include('disabled')
    remove.click

    remove = page.find('a', text: 'Verwijder doel')
    add = page.find('a', text: 'Voeg doel toe')
    expect(add[:class]).not_to include('disabled')
    expect(remove[:class]).to include('disabled')

    10.times { |_x| add.click }

    remove = page.find('a', text: 'Verwijder doel')
    add = page.find('a', text: 'Voeg doel toe')
    expect(add[:class]).to include('disabled')
    expect(remove[:class]).not_to include('disabled')
  end

  it 'requires radio buttons to be filled out' do
    protocol_subscription = FactoryBot.create(:protocol_subscription,
                                              start_date: 1.week.ago.at_beginning_of_day,
                                              person: student)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    open_from: 1.hour.ago)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
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

  it 'shows an informed consent questionnaire' do
    protocol = FactoryBot.create(:protocol, :with_informed_consent_questionnaire)
    expect(protocol.informed_consent_questionnaire).not_to be_nil
    expect(protocol.informed_consent_questionnaire.title).to eq 'Informed Consent'
    protocol_subscription = FactoryBot.create(:protocol_subscription,
                                              start_date: 1.week.ago.at_beginning_of_day,
                                              protocol: protocol,
                                              person: student)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    open_from: 1.hour.ago)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    expect(responseobj.completed_at).to be_nil
    expect(responseobj.content).to be_nil
    expect(responseobj.values).to be_nil
    expect(responseobj.opened_at).to be_nil
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
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
    expect(responseobj.content).not_to be_nil
    expect(responseobj.values).to include('v1' => 'slecht',
                                          'v2_brood' => 'true',
                                          'v2_kaas_en_ham' => 'true',
                                          'v3' => '57')
  end

  it 'does not accept strings longer than the max' do
    protocol_subscription = FactoryBot.create(:protocol_subscription,
                                              start_date: 1.week.ago.at_beginning_of_day,
                                              person: student)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    open_from: 1.hour.ago)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
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
      { questions: [{
        id: :v1,
        type: :radio,
        title: 'Hoe voelt u zich vandaag?',
        options: %w[slecht goed]
      }, {
        id: :v2,
        type: :checkbox,
        title: 'Wat heeft u vandaag gegeten?',
        options: [
          { title: 'brood', hides_questions: %i[v3] },
          'kaas en ham',
          { title: 'pizza', shows_questions: %i[v4 v5], tooltip: 'some text' }
        ]
      }, {
        section_start: 'My hidden question',
        id: :v3,
        hidden: false,
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
      }], scores: [] }
    end

    it 'shows and hides questions' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_content('Hoe voelt u zich vandaag?')
      expect(page).to have_content('slecht')
      expect(page).to have_content('goed')
      expect(page).to have_content('My hidden question')
      expect(page).to have_content('Zie je mij of niet?')
      expect(page).to have_content('helemaal wel')
      expect(page).to have_content('helemaal niet')
      expect(page).to have_content('Wat heeft u vandaag gegeten?')
      expect(page).to have_content('brood')
      expect(page).to have_content('kaas en ham')
      expect(page).to have_content('pizza')

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
      # v1
      page.choose('slecht', allow_label_click: true)
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
      page.check('brood', allow_label_click: true)
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
      page.check('pizza', allow_label_click: true)
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
      page.uncheck('pizza', allow_label_click: true)
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
      page.check('pizza', allow_label_click: true)
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
      ## v3
      # range_select('v3', '64')
      # v4
      page.check('antwoord a', allow_label_click: true)
      # v5
      page.choose('hahaha', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'slecht',
                                            'v2_brood' => 'true',
                                            'v2_pizza' => 'true',
                                            'v4_antwoord_a' => 'true',
                                            'v5' => 'hahaha')
    end
    it 'does not prevent from sending invisible answers' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
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
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'slecht')
    end
    it 'requires invisible radios once they become visible' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
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
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'slecht',
                                            'v2_pizza' => 'true',
                                            'v3' => '50',
                                            'v5' => 'Hihaho')
    end
    it 'unsubscribes when the stop_subscription option is selected for students' do
      content = { questions: [{
        id: :v1,
        type: :checkbox,
        title: 'Stop je ermee?',
        options: [
          { title: 'Ja', stop_subscription: true },
          'Nee'
        ]
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.check('Ja', allow_label_click: true)
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      expect(page).to have_content('Je hebt je uitgeschreven voor het '\
                                   "#{Rails.application.config.settings.application_name}"\
                                   ' onderzoek. Bedankt voor je inzet!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1_ja' => 'true')
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq ProtocolSubscription::CANCELED_STATE
      expect(protocol_subscription.end_date).to be_within(1.minute).of(Time.zone.now)
    end
    it 'does not unsubscribe when the stop_subscription option is not selected for students' do
      content = { questions: [{
        id: :v1,
        type: :checkbox,
        title: 'Stop je ermee?',
        options: [
          { title: 'Ja', stop_subscription: true },
          'Nee'
        ]
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      expect(page).not_to have_content('Je hebt je uitgeschreven voor het '\
                                       "#{Rails.application.config.settings.application_name}"\
                                       ' onderzoek. Bedankt voor je inzet!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq ProtocolSubscription::ACTIVE_STATE
      expect(protocol_subscription.end_date).not_to be_within(1.minute).of(Time.zone.now)
    end
    it 'unsubscribes when the stop_subscription option is selected for mentors' do
      content = { questions: [{
        id: :v1,
        type: :checkbox,
        title: 'Stop je ermee?',
        options: [
          { title: 'Ja', stop_subscription: true },
          'Nee'
        ]
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                :mentor,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: mentor)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('Webapp Begeleiders')
      page.click_on 'Vragenlijst invullen voor deze student'
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.check('Ja', allow_label_click: true)
      page.click_on 'Opslaan'
      expect(page).to have_content('Webapp Begeleiders')
      expect(page).to have_content('Succes: De begeleiding voor Jane is gestopt.')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1_ja' => 'true')
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq ProtocolSubscription::CANCELED_STATE
      expect(protocol_subscription.end_date).to be_within(1.minute).of(Time.zone.now)
    end
    it 'does not unsubscribe when the stop_subscription option is not selected for mentors' do
      content = { questions: [{
        id: :v1,
        type: :checkbox,
        title: 'Stop je ermee?',
        options: [
          { title: 'Ja', stop_subscription: true },
          'Nee'
        ]
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                :mentor,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: mentor)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('Webapp Begeleiders')
      page.click_on 'Vragenlijst invullen voor deze student'
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.check('Nee', allow_label_click: true)
      page.click_on 'Opslaan'
      expect(page).to have_content('Webapp Begeleiders')
      expect(page).not_to have_content('Succes: De begeleiding voor Jane is gestopt.')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1_nee' => 'true')
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq ProtocolSubscription::ACTIVE_STATE
      expect(protocol_subscription.end_date).not_to be_within(1.minute).of(Time.zone.now)
    end
  end

  context 'shows and hides radio questions' do
    let(:content) do
      { questions: [
        {
          id: :v1,
          type: :checkbox,
          title: 'Hoe voelt u zich vandaag?',
          options: %w[slecht goed]
        }, {
          id: :v2,
          type: :radio,
          title: 'Wat heeft u vandaag gegeten?',
          options: [
            { title: 'brood', hides_questions: %i[v3] },
            'kaas en ham',
            { title: 'pizza', shows_questions: %i[v4 v5], tooltip: 'some text' }
          ]
        }, {
          section_start: 'My hidden question',
          id: :v3,
          hidden: false,
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
        }
      ], scores: [] }
    end

    it 'shows and hides questions' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_content('Hoe voelt u zich vandaag?')
      expect(page).to have_content('slecht')
      expect(page).to have_content('goed')
      expect(page).to have_content('Wat heeft u vandaag gegeten?')
      expect(page).to have_content('brood')
      expect(page).to have_content('kaas en ham')
      expect(page).to have_content('pizza')
      expect(page).to have_content('My hidden question')
      expect(page).to have_content('Zie je mij of niet?')
      expect(page).to have_content('helemaal wel')
      expect(page).to have_content('helemaal niet')

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
      # v1
      page.check('slecht', allow_label_click: true)
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
      page.choose('brood', allow_label_click: true)
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
      page.choose('pizza', allow_label_click: true)
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
      page.choose('kaas en ham', allow_label_click: true)
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
      page.choose('pizza', allow_label_click: true)
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
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1_slecht' => 'true',
                                            'v2' => 'pizza',
                                            'v3' => '64',
                                            'v4_antwoord_a' => 'true',
                                            'v5' => 'hahaha')
    end
    it 'does not prevent from sending invisible answers' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
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
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v2' => 'brood')
      expect(responseobj.values.keys).not_to include('v3')
    end
    it 'requires invisible radios once they become visible' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
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
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1_goed' => 'true',
                                            'v2' => 'pizza',
                                            'v3' => '50',
                                            'v5' => 'Hihaho')
    end
    it 'unsubscribes when the stop_subscription option is selected for students' do
      content = { questions: [{
        id: :v1,
        type: :radio,
        title: 'Stop je ermee?',
        options: [
          { title: 'Ja', stop_subscription: true },
          'Nee'
        ]
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.choose('Ja', allow_label_click: true)
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      expect(page).to have_content('Je hebt je uitgeschreven voor het '\
                                   "#{Rails.application.config.settings.application_name}"\
                                   ' onderzoek. Bedankt voor je inzet!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'Ja')
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq ProtocolSubscription::CANCELED_STATE
      expect(protocol_subscription.end_date).to be_within(1.minute).of(Time.zone.now)
    end
    it 'does not unsubscribe when the stop_subscription option is not selected for students' do
      content = { questions: [{
        id: :v1,
        type: :radio,
        title: 'Stop je ermee?',
        options: [
          { title: 'Ja', stop_subscription: true },
          'Nee'
        ]
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.choose('Nee', allow_label_click: true)
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      expect(page).not_to have_content(
        "Je hebt je uitgeschreven voor het #{ENV['PROJECT_NAME']} onderzoek. Bedankt voor je inzet!"
      )
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'Nee')
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq ProtocolSubscription::ACTIVE_STATE
      expect(protocol_subscription.end_date).not_to be_within(1.minute).of(Time.zone.now)
    end

    it 'unsubscribes when the stop_subscription option is selected for mentors' do
      content = { questions: [{
        id: :v1,
        type: :radio,
        title: 'Stop je ermee?',
        options: [
          { title: 'Ja', stop_subscription: true },
          'Nee'
        ]
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                :mentor,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: mentor)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('Webapp Begeleiders')
      page.click_on 'Vragenlijst invullen voor deze student'
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.choose('Ja', allow_label_click: true)
      page.click_on 'Opslaan'
      expect(page).to have_content('Webapp Begeleiders')
      expect(page).to have_content('Succes: De begeleiding voor Jane is gestopt.')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'Ja')
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq ProtocolSubscription::CANCELED_STATE
      expect(protocol_subscription.end_date).to be_within(1.minute).of(Time.zone.now)
    end
    it 'does not unsubscribe when the stop_subscription option is not selected for mentors' do
      content = { questions: [{
        id: :v1,
        type: :radio,
        title: 'Stop je ermee?',
        options: [
          { title: 'Ja', stop_subscription: true },
          'Nee'
        ]
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                :mentor,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: mentor)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('Webapp Begeleiders')
      page.click_on 'Vragenlijst invullen voor deze student'
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.choose('Nee', allow_label_click: true)
      page.click_on 'Opslaan'
      expect(page).to have_content('Webapp Begeleiders')
      expect(page).not_to have_content('Succes: De begeleiding voor Jane is gestopt.')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'Nee')
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq ProtocolSubscription::ACTIVE_STATE
      expect(protocol_subscription.end_date).not_to be_within(1.minute).of(Time.zone.now)
    end
  end

  context 'textarea' do
    let(:content) do
      { questions: [
        {
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
        }
      ], scores: [] }
    end

    it 'stores the results from a textarea' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
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
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'pizza',
                                            'v3' => 'of niet soms')
    end
    it 'requires required textareas to be filled out' do
      content = { questions: [
        {
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
          required: true,
          type: :textarea,
          title: 'Zie je mij of niet?',
          section_end: true
        }, {
          id: :v3,
          type: :textarea,
          required: true,
          title: 'Dit is je tekstruimte'
        }
      ], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_css('label', text: 'Vul iets in', visible: false)
      expect(page).to have_css('p', text: 'Dit is je tekstruimte', visible: false)
      # required field v3 blank: page should not change:
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      # v1
      page.choose('brood', allow_label_click: true)
      expect(page).to have_css('label', text: 'Vul iets in', visible: true)
      expect(page).to have_css('p', text: 'Dit is je tekstruimte', visible: true)
      # v3
      page.fill_in('v3', with: 'of niet soms')
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_nil
      expect(responseobj.content).to be_nil
      # v2
      page.fill_in('v2', with: 'hoi')
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'brood',
                                            'v2' => 'hoi',
                                            'v3' => 'of niet soms')
    end
    it 'does not require hidden required textareas to be filled out' do
      content = { questions: [{
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
        required: true,
        type: :textarea,
        title: 'Zie je mij of niet?',
        section_end: true
      }, {
        id: :v3,
        type: :textarea,
        required: true,
        title: 'Dit is je tekstruimte'
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_css('label', text: 'Vul iets in', visible: false)
      expect(page).to have_css('p', text: 'Dit is je tekstruimte', visible: false)
      # required field v3 blank: page should not change:
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      # v3
      page.choose('pizza', allow_label_click: true)
      page.fill_in('v3', with: 'of niet soms')
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'pizza',
                                            'v3' => 'of niet soms')
      expect(responseobj.values.keys).not_to include('v2')
    end
    it 'does not require textareas to be filled out if they are not required' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
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
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'brood',
                                            'v3' => 'of niet soms')
    end
  end

  context 'textfield' do
    let(:content) do
      { questions: [
        {
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
          type: :textfield,
          title: 'Zie je mij of niet?',
          section_end: true
        }, {
          id: :v3,
          type: :textfield,
          title: 'Dit is je tekstruimte'
        }
      ], scores: [] }
    end

    it 'stores the results from a textfield' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
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
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'pizza',
                                            'v3' => 'of niet soms')
    end
    it 'supports the default_value property' do
      content = { questions: [{
        id: :v1,
        type: :textfield,
        title: 'Dit is je tekstruimte',
        required: true,
        default_value: 'ga zo door en nog een woord'
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'ga zo door en nog een woord')
    end
    it 'requires required textfields to be filled out' do
      content = { questions: [{
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
        required: true,
        type: :textfield,
        title: 'Zie je mij of niet?',
        section_end: true
      }, {
        id: :v3,
        type: :textfield,
        required: true,
        title: 'Dit is je tekstruimte'
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_css('label', text: 'Vul iets in', visible: false)
      expect(page).to have_css('p', text: 'Dit is je tekstruimte', visible: false)
      # required field v3 blank: page should not change:
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      # v1
      page.choose('brood', allow_label_click: true)
      expect(page).to have_css('label', text: 'Vul iets in', visible: true)
      expect(page).to have_css('p', text: 'Dit is je tekstruimte', visible: true)
      # v3
      page.fill_in('v3', with: 'of niet soms')
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_nil
      expect(responseobj.content).to be_nil
      # v2
      page.fill_in('v2', with: 'hoi')
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'brood',
                                            'v2' => 'hoi',
                                            'v3' => 'of niet soms')
    end
    it 'does not require hidden required textfields to be filled out' do
      content = { questions: [{
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
        required: true,
        type: :textfield,
        title: 'Zie je mij of niet?',
        section_end: true
      }, {
        id: :v3,
        type: :textfield,
        required: true,
        title: 'Dit is je tekstruimte'
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_css('label', text: 'Vul iets in', visible: false)
      expect(page).to have_css('p', text: 'Dit is je tekstruimte', visible: false)
      # required field v3 blank: page should not change:
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      # v3
      page.choose('pizza', allow_label_click: true)
      page.fill_in('v3', with: 'of niet soms')
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'pizza',
                                            'v3' => 'of niet soms')
      expect(responseobj.values.keys).not_to include('v2')
    end
    it 'does not require textfields to be filled out if they are not required' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
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
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'brood',
                                            'v3' => 'of niet soms')
    end
  end

  it 'has tooltips, and show a toast when they are clicked' do
    protocol_subscription = FactoryBot.create(:protocol_subscription,
                                              person: student,
                                              start_date: 1.week.ago.at_beginning_of_day)
    responseobj = FactoryBot.create(:response, :invited,
                                    protocol_subscription: protocol_subscription,
                                    open_from: 1.hour.ago)
    invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
    visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    expect(page).not_to have_content('hagelslag')
    # We can serch for all, because theres just one with a tooltip
    page.all('i').first.click
    expect(page).to have_content('hagelslag')
  end

  describe 'multiple available questionnaires' do
    let(:content) do
      { questions: [
        {
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
          required: true,
          type: :textfield,
          title: 'Zie je mij of niet?',
          section_end: true
        }, {
          id: :v3,
          type: :textfield,
          required: true,
          title: 'Dit is je tekstruimte'
        }
      ], scores: [] }
    end
    let(:number_of_available_questionnaires) { 3 }

    it 'opens the second questionnaire after the first one if it is open' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responses = Array.new(number_of_available_questionnaires).map do
        FactoryBot.create(:response, :invited,
                          protocol_subscription: protocol_subscription,
                          measurement: measurement,
                          open_from: 1.hour.ago)
      end
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responses.first.invitation_set)
      visit responses.first.invitation_set.invitation_url(invitation_token.token_plain, false)

      responses.each_with_index do |responseobj, idx|
        expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
        expect(page).not_to have_current_path(mentor_overview_index_path)
        # expect(page).to have_http_status(200)
        expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
        # v1
        page.choose('pizza', allow_label_click: true)
        page.fill_in('v3', with: 'of niet soms')
        page.click_on 'Opslaan'
        # expect(page).to have_http_status(200)
        unless number_of_available_questionnaires == idx + 1
          expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
        end
      end

      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')

      responses.each do |responseobj|
        responseobj.reload
        expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
        expect(responseobj.content).not_to be_nil
        expect(responseobj.values).to include('v1' => 'pizza',
                                              'v3' => 'of niet soms')
      end
    end
  end

  context 'show_after' do
    it 'shows items that have a show after duration that is past' do
      content = { questions: [{
        type: :raw,
        content: '<p class="flow-text section-explanation">Wie is de mol?</p>',
        show_after: 1.day
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('Wie is de mol?')
    end
    it 'does not show items that have a show after duration that is future' do
      content = { questions: [{
        type: :raw,
        content: '<p class="flow-text section-explanation">Wie is de mol?</p>',
        show_after: 2.weeks
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).not_to have_content('Wie is de mol?')
    end
    it 'shows items that have a show after absolute time that is past' do
      content = { questions: [{
        type: :raw,
        content: '<p class="flow-text section-explanation">Wie is de mol?</p>',
        show_after: 5.minutes.ago
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('Wie is de mol?')
    end
    it 'does not show items that have a show after absolute time that is future' do
      content = { questions: [{
        type: :raw,
        content: '<p class="flow-text section-explanation">Wie is de mol?</p>',
        show_after: 2.days.from_now
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).not_to have_content('Wie is de mol?')
    end
    it 'should not show items that should only be visible on the final questionnaire' do
      content = { questions: [{
        type: :raw,
        content: '<p class="flow-text section-explanation">Wie is de mol?</p>',
        show_after: :only_on_final_questionnaire
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      FactoryBot.create(:response, :invited,
                        protocol_subscription: protocol_subscription,
                        measurement: measurement,
                        open_from: 1.hour.from_now)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to_not have_content('Wie is de mol?')
    end
    it 'should show items that should only be visible on the final questionnaire when on it' do
      content = { questions: [{
        type: :raw,
        content: '<p class="flow-text section-explanation">Wie is de mol?</p>',
        show_after: :only_on_final_questionnaire
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      FactoryBot.create(:response, :invited,
                        protocol_subscription: protocol_subscription,
                        measurement: measurement,
                        open_from: 7.days.ago)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('Wie is de mol?')
    end
  end

  context 'unsubscribe' do
    it 'works without specifying title, content, and button text' do
      content = { questions: [{
        type: :unsubscribe
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('Uitschrijven')
    end
    it 'works when specifying title, content, and button text' do
      content = { questions: [{
        type: :unsubscribe,
        title: 'Creativity Inc',
        content: 'Overcoming the unseen forces that stand in the way of true inspiration',
        button_text: 'Edwin Catmull'
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_content('Creativity Inc')
      expect(page).to have_content('Overcoming the unseen forces that stand in the way of true inspiration')
      expect(page).to have_content('Edwin Catmull')
    end

    it 'redirects to the stop_measurement if one is available' do
      content = { questions: [{
        type: :unsubscribe,
        title: 'Creativity Inc',
        content: 'Overcoming the unseen forces that stand in the way of true inspiration',
        button_text: 'Unsubscribe'
      }], scores: [] }

      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)

      questionnaire_unsub = FactoryBot.create(:questionnaire, content: content)
      post_questionnaire = FactoryBot.create(:questionnaire, content: { questions: [{
                                               id: :v3,
                                               type: :range,
                                               title: 'Hoe gaat het met u?',
                                               labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens']
                                             }], scores: [] })

      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire_unsub, protocol: protocol)
      stop_measurement = FactoryBot.create(:measurement, :stop_measurement,
                                           questionnaire: post_questionnaire, protocol: protocol)

      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)

      FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                   measurement: stop_measurement, open_from: 10.minutes.ago)

      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      page.click_on 'Unsubscribe'
      expect(page).not_to have_content('Bedankt voor je inzet!')
      expect(page).not_to have_content(content[:questions].first[:content])
      expect(page).to have_content('Hoe gaat het met u?')
      expect(page).to have_content('Opslaan')
      protocol_subscription.reload
      expect(protocol_subscription).to be_active
      page.click_on 'Opslaan'
      expect(page).not_to have_content('Hoe gaat het met u?')
      expect(page).to have_content('Bedankt voor je inzet!')
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq(ProtocolSubscription::CANCELED_STATE)
    end

    it 'redirects to the destroy page if no stop_measurement is available' do
      content = { questions: [{
        type: :unsubscribe,
        title: 'Creativity Inc',
        content: 'Overcoming the unseen forces that stand in the way of true inspiration',
        button_text: 'Unsubscribe'
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      page.click_on 'Unsubscribe'
      expect(page).to have_content('Bedankt voor je inzet!')
      protocol_subscription.reload
      expect(protocol_subscription.state).to eq(ProtocolSubscription::CANCELED_STATE)
    end
  end

  describe 'with redirect url' do
    let(:redirect_url) { '/api/v1/statistics' }

    it 'redirects to the redirect url of a provided measurement if it has one' do
      content = { questions: [{
        id: :v1,
        type: :radio,
        title: 'Wat heeft u vandaag gegeten?',
        options: [
          { title: 'brood' },
          'pizza'
        ]
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol,
                                                    redirect_url: redirect_url)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      page.choose('brood', allow_label_click: true)
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      # Just check a simple URL to see if it has redirected correctly.

      expect(page).to have_content('number_of_students')
      expect(page).to have_content('number_of_mentors')
      expect(page).to have_content('duration_of_project_in_weeks')
      expect(page).to have_content('number_of_completed_questionnaires')
      responseobj.reload
    end
  end

  context 'date' do
    let(:content) do
      { questions: [{
        id: :v1,
        type: :date,
        title: 'Welke dag is het vandaag?'
      }], scores: [] }
    end

    it 'stores the results from a date' do
      # Don't test min and max right now because they are bugged
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      page.find('#v1').click
      sleep(1)
      page.find('.is-today').click
      page.click_on 'Ok'
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => Time.zone.today.to_formatted_s(:db))
    end
    it 'supports the today property, which sets the default value to today' do
      # Don't test min and max right now because they are bugged
      content = { questions: [{
        id: :v1,
        type: :date,
        required: true,
        today: true,
        title: 'Welke dag is het vandaag?'
      }], scores: [] }
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => Time.zone.today.to_formatted_s(:db))
    end
  end

  context 'likert' do
    let(:content) do
      { questions: [{
        id: :v1,
        type: :likert,
        title: 'Welke dag is het vandaag?',
        options: %w[maandag dinsdag woensdag]
      }], scores: [] }
    end

    it 'stores the results from a likert scale' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_content(content[:questions].first[:title])
      page.choose('v1_maandag', allow_label_click: true)
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'maandag')
    end

    it 'makes likert scales mandatory' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      page.click_on 'Opslaan'
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_blank
      expect(responseobj.values).to be_blank
    end
  end

  context 'drawing' do
    let(:content) do
      { questions: [{
        id: :v1,
        type: :drawing,
        title: 'Kleur de plekken in je lichaam waar je merkt dat het sterker wordt',
        width: 240,
        height: 536,
        image: 'bodymap.png',
        color: '#e57373'
      }], scores: [] }
    end

    it 'stores the results from a drawing', js: true do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_content(content[:questions].first[:title])
      page.find(:css, 'canvas').click
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
    end

    it 'does not make drawings mandatory', js: true do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  context 'dropdown' do
    let(:content) do
      { questions: [{
        id: :v1,
        type: :dropdown,
        title: 'Welke dag is het vandaag?',
        options: %w[maandag dinsdag woensdag],
        label: 'Dag van de week',
        placeholder: 'Selecteer een dag'
      }], scores: [] }
    end

    it 'stores the results from a dropdown' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_content(content[:questions].first[:title])
      page.select 'dinsdag'
      # materialize_select('Selecteer een dag', 'dinsdag')
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => 'dinsdag')
    end

    it 'makes dropdowns required' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      page.click_on 'Opslaan'
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_blank
      expect(responseobj.values).to be_blank
    end
  end

  context 'number' do
    let(:content) do
      { questions: [{
        id: :v1,
        type: :number,
        title: 'Noem een getal tussen 0 en 9999!',
        maxlength: 4,
        placeholder: '1234',
        required: true,
        min: 0,
        max: 9999
      }], scores: [] }
    end

    it 'stores the results from a number' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      expect(page).not_to have_current_path(mentor_overview_index_path)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_content(content[:questions].first[:title])
      page.fill_in 'v1', with: '2345'
      page.click_on 'Opslaan'
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
      expect(responseobj.content).not_to be_nil
      expect(responseobj.values).to include('v1' => '2345')
    end

    it 'does not accept incorrect input' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, content: content)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      expect(page).to have_current_path(questionnaire_path(uuid: responseobj.uuid))
      page.fill_in 'v1', with: '-1'
      page.click_on 'Opslaan'
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      page.fill_in 'v1', with: '-234'
      page.click_on 'Opslaan'
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      page.fill_in 'v1', with: '10000'
      page.click_on 'Opslaan'
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      page.fill_in 'v1', with: 'asdf'
      page.click_on 'Opslaan'
      expect(page).not_to have_content('Bedankt voor het invullen van de vragenlijst!')
      responseobj.reload
      expect(responseobj.values).to be_blank
      expect(responseobj.completed_at).to be_blank
    end
  end

  context 'callback_url' do
    it 'redirects after filling out a questionnaire if a callback_url is supplied' do
      protocol = FactoryBot.create(:protocol)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                protocol: protocol,
                                                person: student)
      questionnaire = FactoryBot.create(:questionnaire, :minimal)
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire, protocol: protocol)
      responseobj = FactoryBot.create(:response, :invited,
                                      protocol_subscription: protocol_subscription,
                                      measurement: measurement,
                                      open_from: 1.hour.ago)
      invitation_token = FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set)
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      visit "#{questionnaire_path(uuid: responseobj.uuid)}?callback_url=%2Fperson%2Fedit"
      expect(page).to have_current_path("#{questionnaire_path(uuid: responseobj.uuid)}?callback_url=%2Fperson%2Fedit")
      expect(page).not_to have_current_path(mentor_overview_index_path)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      expect(page).to have_content('Hoihoihoi')
      page.click_on 'Opslaan'
      expect(page).to have_content(person_header)
    end
  end
end
