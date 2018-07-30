# frozen_string_literal: true

require 'rails_helper'

describe 'GET /klaar', type: :feature, js: true do
  context 'Student' do
    let(:protocol_with_rewards) { FactoryBot.create(:protocol, :with_rewards) }

    let(:protocol_subscription) do
      FactoryBot.create(:protocol_subscription,
                        protocol: protocol_with_rewards,
                        start_date: 1.week.ago.at_beginning_of_day)
    end

    let!(:responseobj) do
      FactoryBot.create(:response, :periodical, :invited,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.hour.ago)
    end

    let!(:invtoken) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

    def fill_out_questionnaire
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.choose('slecht', allow_label_click: true)
      # v2
      page.check('brood', allow_label_click: true)
      page.check('kaas en ham', allow_label_click: true)
      # v3
      range_select('v3', '57')
      page.click_on 'Opslaan'
    end

    it 'should be redirected after a questionnaire to the rewards page' do
      FactoryBot.create(:response,
                        :periodical, protocol_subscription: protocol_subscription,
                                     open_from: 1.day.from_now)
      FactoryBot.create(:response, :completed,
                        :periodical,
                        protocol_subscription: protocol_subscription,
                        open_from: 2.days.ago)
      expect(Reward.total_earned_euros(bust_cache: true)).to eq 1.0
      expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 2.0

      visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
      # expect(page).to have_http_status(200)
      fill_out_questionnaire
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      protocol_subscription.reload
      expect(Reward.total_earned_euros(bust_cache: true)).to eq 2.0
      expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 1.0
      expect(page).to have_content('Je hebt hiermee €1,- verdiend.')
      expect(page).not_to have_content('Het onderzoek is voor 67% voltooid. Er is nog €1,- te verdienen.')
      expect(page).not_to have_content('Heel erg bedankt voor je inzet voor dit onderzoek!')
      expect(page).not_to have_content('IBAN')
      expect(page).not_to have_content('aan te passen')
    end

    it 'should show the earned page when done with the research' do
      FactoryBot.create(:response, :completed,
                        :periodical, protocol_subscription: protocol_subscription,
                                     open_from: 1.day.ago)
      FactoryBot.create(:response, :completed,
                        :periodical, protocol_subscription: protocol_subscription,
                                     open_from: 2.days.ago)
      expect(Reward.total_earned_euros(bust_cache: true)).to eq 2.0
      expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 1.0
      visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
      # expect(page).to have_http_status(200)
      fill_out_questionnaire
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      protocol_subscription.reload
      expect(Reward.total_earned_euros(bust_cache: true)).to eq 3.0
      expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 0.0
      expect(page).to have_content('Heel erg bedankt voor je inzet voor dit onderzoek!')
      expect(page).to have_content('€0,03 verdiend.')
      expect(page).to have_content('IBAN')
      expect(page).to have_content('aan te passen')
    end

    it 'should show the disclaimer link on the reward page' do
      FactoryBot.create(:response, :completed,
                        :periodical,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.day.ago)
      FactoryBot.create(:response, :completed,
                        :periodical,
                        protocol_subscription: protocol_subscription,
                        open_from: 2.days.ago)
      visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
      fill_out_questionnaire
      expect(page).to have_link('Disclaimer', href: '/disclaimer')
    end

    it 'should be redirected after a questionnaire to the rewards page from tokenauth controller' do
      FactoryBot.create(:response,
                        :periodical,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.day.from_now)
      FactoryBot.create(:response, :completed,
                        :periodical,
                        protocol_subscription: protocol_subscription,
                        open_from: 2.days.ago)
      expect(Reward.total_earned_euros(bust_cache: true)).to eq 1.0
      expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 2.0
      visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
      # expect(page).to have_http_status(200)
      fill_out_questionnaire
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      protocol_subscription.reload
      expect(Reward.total_earned_euros(bust_cache: true)).to eq 2.0
      expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 1.0
      expect(page).to have_content('Je hebt hiermee €1,- verdiend.')
      expect(page).to_not have_content('Het onderzoek is voor 67% voltooid. Er is nog €1,- te verdienen.')
    end
  end

  context 'Mentor' do
    let(:person) { FactoryBot.create(:mentor) }
    let(:protocol_subscription) do
      FactoryBot.create(:protocol_subscription,
                        start_date: 1.week.ago.at_beginning_of_day,
                        person: person)
    end

    let(:responseobj) do
      FactoryBot.create(:response, :invited,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.hour.ago)
    end

    let!(:completed_responseobj) do
      FactoryBot.create(:response, :completed,
                        protocol_subscription: protocol_subscription,
                        open_from: 2.days.ago)
    end

    let!(:invitation_token) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

    it 'should not show rewards for Mentors, and it should redirect back to the webapp' do
      expect(Reward.total_earned_euros(bust_cache: true)).to eq 0.0
      expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 0.0
      visit responseobj.invitation_set.invitation_url(invitation_token.token_plain, false)
      # expect(page).to have_http_status(200)
      expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
      # v1
      page.choose('slecht', allow_label_click: true)
      # v2
      page.check('brood', allow_label_click: true)
      page.check('kaas en ham', allow_label_click: true)
      # v3
      range_select('v3', '57')
      page.click_on 'Opslaan'
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Webapp Begeleiders')
      protocol_subscription.reload
      expect(Reward.total_earned_euros(bust_cache: true)).to eq 0.0
      expect(Reward.max_still_earnable_euros(bust_cache: true)).to eq 0.0
      expect(page).not_to have_content('Je hebt hiermee €1,- verdiend.')
      expect(page).not_to have_content('Je hebt nu in totaal')
      expect(page).not_to have_content('euro')
      expect(page).not_to have_content('€')
      expect(page).not_to have_content('Het onderzoek is voor 67% voltooid. Er is nog €1,- te verdienen.')
    end
  end
end
