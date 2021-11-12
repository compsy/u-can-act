# frozen_string_literal: true

require 'rails_helper'

describe 'GET /edit', type: :feature, js: true do
  let(:person_header) { 'Accountgegevens bewerken' }
  let(:person_body) { 'Pas hier uw persoonsgegevens aan' }
  describe 'Mentor' do
    let!(:mentor) { FactoryBot.create(:mentor, gender: 'female') }

    let(:protocol_with_rewards) { FactoryBot.create(:protocol, :with_rewards) }

    let(:protocol_subscription) do
      FactoryBot.create(:protocol_subscription,
                        protocol: protocol_with_rewards,
                        person: mentor,
                        start_date: 1.week.ago.at_beginning_of_day)
    end

    let!(:responseobj) do
      FactoryBot.create(:response, :periodical, :invited,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.hour.ago)
    end
    let!(:invtoken) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

    before do
      # Login
      visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
    end

    it 'lists the correct labels / fields' do
      visit edit_person_path
      expect(page).not_to have_content('Bankgegevens')
      expect(page).to have_content(person_header)
      expect(page).to have_content('Voornaam')
      expect(page).to have_content('Achternaam')
      expect(page).to have_content('Geslacht')
      expect(page).to have_content('E-mailadres')
      expect(page).to have_content('Mobiele telefoonnummer')
      expect(page).not_to have_content('Bankrekeningnummer (IBAN)')
    end

    it 'stores data after clicking the update button' do
      visit edit_person_path
      expect(page).not_to have_content('Bankgegevens')
      expect(page).to have_content(person_header)
      page.fill_in('person_first_name', with: 'new_first')
      page.fill_in('person_last_name', with: 'new_last')
      page.fill_in('person_mobile_phone', with: '0698417313')
      page.fill_in('person_email', with: 'anew@email.com')

      page.choose('Man', allow_label_click: true)

      all('button[type="submit"]').first.click
      visit edit_person_path

      expect(page).to have_selector("input[value='new_first']")
      expect(page).to have_selector("input[value='new_last']")
      expect(page).to have_selector("input[value='0698417313']")
      expect(page).to have_selector("input[value='anew@email.com']")
      expect(find("[name='person[gender]'][checked]").value).to eq 'male'
    end

    it 'actually updates the person object' do
      expect(mentor.first_name).not_to eq 'new_first'
      expect(mentor.last_name).not_to eq 'new_last'
      expect(mentor.mobile_phone).not_to eq '0698417313'
      expect(mentor.email).not_to eq 'anew@email.com'

      visit edit_person_path
      pre_iban = mentor.iban

      expect(page).not_to have_content('Bankgegevens')
      expect(page).to have_content(person_header)
      page.fill_in('person_first_name', with: 'new_first')
      page.fill_in('person_last_name', with: 'new_last')
      page.fill_in('person_mobile_phone', with: '0698417313')
      page.fill_in('person_email', with: 'anew@email.com')
      page.choose('Man', allow_label_click: true)
      all('button[type="submit"]').first.click

      mentor.reload

      expect(mentor.first_name).to eq 'new_first'
      expect(mentor.last_name).to eq 'new_last'
      expect(mentor.mobile_phone).to eq '0698417313'
      expect(mentor.email).to eq 'anew@email.com'
      expect(mentor.iban).to eq(pre_iban)
    end
  end

  describe 'Solo' do
    let!(:solo) { FactoryBot.create(:solo, gender: 'female') }

    let(:protocol_with_rewards) { FactoryBot.create(:protocol, :with_rewards) }

    let(:protocol_subscription) do
      FactoryBot.create(:protocol_subscription,
                        protocol: protocol_with_rewards,
                        person: solo,
                        start_date: 1.week.ago.at_beginning_of_day)
    end

    let!(:responseobj) do
      FactoryBot.create(:response, :periodical, :invited,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.hour.ago)
    end
    let!(:invtoken) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

    before do
      # Login
      visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
    end

    it 'lists the correct labels / fields' do
      visit edit_person_path
      expect(page).not_to have_content('Bankgegevens')
      expect(page).to have_content(person_header)
      expect(page).to have_content(person_body)
      expect(page).not_to have_content('Voornaam')
      expect(page).not_to have_content('Achternaam')
      expect(page).not_to have_content('Geslacht')
      expect(page).to have_content('E-mailadres')
      expect(page).not_to have_content('Mobiele telefoonnummer')
      expect(page).not_to have_content('Bankrekeningnummer (IBAN)')
      expect(page).not_to have_content('Disclaimer')
      expect(page).not_to have_content('Gegevens aanpassen')
    end

    it 'stores data after clicking the update button' do
      visit edit_person_path
      page.fill_in('person_email', with: 'anew@email.com')

      all('button[type="submit"]').first.click
      visit edit_person_path

      expect(page).to have_selector("input[value='anew@email.com']")
    end

    it 'actuallies update the person object' do
      expect(solo.email).not_to eq 'anew@email.com'

      visit edit_person_path

      page.fill_in('person_email', with: 'anew@email.com')
      all('button[type="submit"]').first.click

      solo.reload

      expect(solo.email).to eq 'anew@email.com'
    end
    it 'redirects to the correct page' do
      responseobj.complete!
      sleep(1)
      visit edit_person_path
      page.fill_in('person_email', with: 'anew@email.com')
      sleep(1)
      all('button[type="submit"]').first.click
      sleep(10)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      expect(page).to have_content('Gegevens opgeslagen')
      expect(page).to have_content('Disclaimer')
      expect(page).to have_content('Gegevens aanpassen')
    end
    it 'requires a valid email' do
      visit edit_person_path
      responseobj.complete!
      page.fill_in('person_email', with: 'anewemail.com')
      all('button[type="submit"]').first.click
      expect(page)
        .not_to have_content('Bedankt voor het invullen van de vragenlijst, je antwoorden zijn opgeslagen.')
      expect(page).not_to have_content('Gegevens opgeslagen')
    end
  end

  describe 'Student' do
    let!(:student) { FactoryBot.create(:student, gender: 'female') }

    let(:protocol_with_rewards) { FactoryBot.create(:protocol, :with_rewards) }

    let(:protocol_subscription) do
      FactoryBot.create(:protocol_subscription,
                        protocol: protocol_with_rewards,
                        person: student,
                        start_date: 1.week.ago.at_beginning_of_day)
    end

    let!(:responseobj) do
      FactoryBot.create(:response, :periodical, :invited,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.hour.ago)
    end
    let!(:invtoken) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

    before do
      # Login
      visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
    end

    describe 'without iban' do
      before :each do
        @initial_value = Rails.application.config.settings.hide_edit_iban
        Rails.application.config.settings.hide_edit_iban = true
      end

      after :each do
        Rails.application.config.settings.hide_edit_iban = @initial_value
      end

      it 'lists the correct labels / fields' do
        visit edit_person_path
        expect(page).to have_content(person_header)
        expect(page).to have_content('Geslacht')
        expect(page).to have_content('Mobiele telefoonnummer')

        expect(page).to_not have_content('Bankgegevens')
        expect(page).to_not have_content('Voornaam')
        expect(page).to_not have_content('Achternaam')
        expect(page).to_not have_content('E-mailadres')
        expect(page).to_not have_content('Bankrekeningnummer (IBAN)')
      end

      it 'stores data after clicking the update button' do
        visit edit_person_path
        expect(page).to_not have_content('Bankgegevens')
        expect(page).to have_content(person_header)
        page.fill_in('person_mobile_phone', with: '0698417312')

        page.choose('Man', allow_label_click: true)

        all('button[type="submit"]').first.click
        visit edit_person_path

        expect(page).to have_selector("input[value='0698417312']")
        expect(find("[name='person[gender]'][checked]").value).to eq 'male'
      end

      it 'actually updates the person object' do
        expect(student.mobile_phone).to_not eq '0698417312'

        visit edit_person_path
        pre_email = student.email
        expect(page).to_not have_content('Bankgegevens')
        expect(page).to have_content(person_header)
        page.fill_in('person_mobile_phone', with: '0698417312')
        page.choose('Man', allow_label_click: true)
        all('button[type="submit"]').first.click

        student.reload

        expect(student.mobile_phone).to eq '0698417312'
        expect(student.email).to eq pre_email
      end
    end

    describe 'with iban' do
      before :each do
        @initial_value = Rails.application.config.settings.hide_edit_iban
        Rails.application.config.settings.hide_edit_iban = false
      end

      after :each do
        Rails.application.config.settings.hide_edit_iban = @initial_value
      end

      it 'lists the correct labels / fields' do
        visit edit_person_path
        expect(page).to have_content('Bankgegevens')
        expect(page).to have_content(person_header)
        expect(page).to have_content('Voornaam')
        expect(page).to have_content('Achternaam')
        expect(page).to have_content('Geslacht')
        expect(page).to_not have_content('E-mailadres')
        expect(page).to have_content('Mobiele telefoonnummer')
        expect(page).to have_content('Bankrekeningnummer (IBAN)')
      end

      it 'stores data after clicking the update button' do
        visit edit_person_path
        expect(page).to have_content('Bankgegevens')
        expect(page).to have_content(person_header)
        page.fill_in('person_first_name', with: 'new_first')
        page.fill_in('person_last_name', with: 'new_last')
        page.fill_in('person_mobile_phone', with: '0698417312')
        page.fill_in('person_iban', with: 'NL13RTEF0518590011')

        page.choose('Man', allow_label_click: true)

        all('button[type="submit"]').first.click
        visit edit_person_path

        expect(page).to have_selector("input[value='new_first']")
        expect(page).to have_selector("input[value='new_last']")
        expect(page).to have_selector("input[value='0698417312']")
        expect(page).to have_selector("input[value='NL13RTEF0518590011']")
        expect(find("[name='person[gender]'][checked]").value).to eq 'male'
      end

      it 'actually updates the person object' do
        expect(student.first_name).to_not eq 'new_first'
        expect(student.last_name).to_not eq 'new_last'
        expect(student.mobile_phone).to_not eq '0698417312'
        expect(student.iban).to_not eq('NL13RTEF0518590011')

        visit edit_person_path
        pre_email = student.email
        expect(page).to have_content('Bankgegevens')
        expect(page).to have_content(person_header)
        page.fill_in('person_first_name', with: 'new_first')
        page.fill_in('person_last_name', with: 'new_last')
        page.fill_in('person_mobile_phone', with: '0698417312')
        page.fill_in('person_iban', with: 'NL13RTEF0518590011')
        page.choose('Man', allow_label_click: true)
        all('button[type="submit"]').first.click

        student.reload

        expect(student.first_name).to eq 'new_first'
        expect(student.last_name).to eq 'new_last'
        expect(student.mobile_phone).to eq '0698417312'
        expect(student.iban).to eq('NL13RTEF0518590011')

        expect(student.email).to eq pre_email
      end
    end
  end
end

describe 'GET /unsubscribe', type: :feature, js: true do
  let!(:person) { FactoryBot.create(:mentor, gender: 'female') }

  let(:protocol) { FactoryBot.create(:protocol) }

  let(:protocol_subscription) do
    FactoryBot.create(:protocol_subscription,
                      :mentor,
                      protocol: protocol,
                      person: person,
                      start_date: 1.week.ago.at_beginning_of_day)
  end

  let!(:responseobj) do
    FactoryBot.create(:response, :periodical, :invited,
                      protocol_subscription: protocol_subscription,
                      open_from: 1.hour.ago)
  end
  let!(:invtoken) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

  before do
    # Login
    visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
  end

  # xit 'should unsubscribe when you click the unsubscribe button' do
  #   expect(page).to have_content('Klaar met dit schooljaar?')
  #   expect(person.protocol_subscriptions.active.count).to eq 1
  #   page.click_on 'Onderzoek afronden'
  #   expect(person.protocol_subscriptions.active.count).to eq 0
  #   expect(page).to have_content('Je hebt je uitgeschreven voor het u-can-act onderzoek. Bedankt voor je inzet!')
  # end
  #
  # xit 'should redirect to a stop questionnaire if there is one and then unsubscribe when click unsubscribe button' do
  #   questionnaire = FactoryBot.create(:questionnaire, :minimal)
  #   measurement = FactoryBot.create(:measurement, :stop_measurement, protocol: protocol, questionnaire: questionnaire)
  #   FactoryBot.create(:response,
  #                     measurement: measurement,
  #                     protocol_subscription: protocol_subscription,
  #                     open_from: 4.hours.from_now)
  #   protocol2 = FactoryBot.create(:protocol)
  #   protocol_subscription2 = FactoryBot.create(:protocol_subscription,
  #                                              :mentor,
  #                                              protocol: protocol,
  #                                              person: person,
  #                                              start_date: 1.week.ago.at_beginning_of_day)
  #   measurement2 = FactoryBot.create(:measurement, :stop_measurement,
  #                                    protocol: protocol2, questionnaire: questionnaire)
  #   FactoryBot.create(:response,
  #                     measurement: measurement2,
  #                     protocol_subscription: protocol_subscription2,
  #                     open_from: 5.hours.from_now)
  #   expect(page).to have_content('Klaar met dit schooljaar?')
  #   expect(person.protocol_subscriptions.active.count).to eq 2
  #   page.click_on 'Onderzoek afronden'
  #   expect(person.protocol_subscriptions.active.count).to eq 2
  #   expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
  #   expect(page).to have_content('Hoihoihoi')
  #   page.click_on 'Opslaan'
  #   expect(person.protocol_subscriptions.active.count).to eq 1
  #   expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
  #   expect(page).to have_content('Hoihoihoi')
  #   page.click_on 'Opslaan'
  #   expect(person.protocol_subscriptions.active.count).to eq 0
  #   expect(page).to have_content('Je hebt je uitgeschreven voor het u-can-act onderzoek. Bedankt voor je inzet!')
  # end
end
