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
      FactoryBot.create(:response, :periodical,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.hour.ago,
                        invited_state: Response::SENT_STATE)
    end

    let!(:invtoken) { FactoryBot.create(:invitation_token, response: responseobj) }

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
                                     open_from: 1.day.from_now,
                                     invited_state: Response::NOT_SENT_STATE)
      FactoryBot.create(:response, :completed,
                        :periodical,
                        protocol_subscription: protocol_subscription,
                        open_from: 2.days.ago)
      expect(protocol_subscription.reward_points).to eq 1
      expect(protocol_subscription.possible_reward_points).to eq 2
      expect(protocol_subscription.max_reward_points).to eq 3

      visit responseobj.invitation_url(false)
      # expect(page).to have_http_status(200)
      fill_out_questionnaire
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      protocol_subscription.reload
      expect(protocol_subscription.reward_points).to eq 2
      expect(protocol_subscription.possible_reward_points).to eq 2
      expect(protocol_subscription.max_reward_points).to eq 3
      expect(page).to have_content('Je hebt hiermee €1,- verdiend.')
      expect(page).not_to have_content('Het onderzoek is voor 67% voltooid. Er is nog €1,- te verdienen.')
      expect(page).not_to have_content('Heel erg bedankt dat je meedeed aan ons onderzoek!')
      expect(page).not_to have_content('S-team')
      expect(page).not_to have_content('beloning')
    end

    it 'should show the earned page when done with the research' do
      FactoryBot.create(:response, :completed,
                        :periodical, protocol_subscription: protocol_subscription,
                                     open_from: 1.day.ago)
      FactoryBot.create(:response, :completed,
                        :periodical, protocol_subscription: protocol_subscription,
                                     open_from: 2.days.ago)
      expect(protocol_subscription.reward_points).to eq 2
      expect(protocol_subscription.possible_reward_points).to eq 3
      expect(protocol_subscription.max_reward_points).to eq 3
      visit responseobj.invitation_url(false)
      # expect(page).to have_http_status(200)
      fill_out_questionnaire
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      protocol_subscription.reload
      expect(protocol_subscription.reward_points).to eq 3
      expect(protocol_subscription.possible_reward_points).to eq 3
      expect(protocol_subscription.max_reward_points).to eq 3
      expect(page).to have_content('Heel erg bedankt dat je meedeed aan ons onderzoek!')
      expect(page).to have_content('€3 verdiend.')
      expect(page).to have_content('S-team')
      expect(page).to have_content('beloning')
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
      visit responseobj.invitation_url(false)
      fill_out_questionnaire
      expect(page).to have_link('Disclaimer', href: '/disclaimer')
    end

    it 'should be redirected after a questionnaire to the rewards page from tokenauth controller' do
      FactoryBot.create(:response,
                        :periodical,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.day.from_now,
                        invited_state: Response::NOT_SENT_STATE)
      FactoryBot.create(:response, :completed,
                        :periodical,
                        protocol_subscription: protocol_subscription,
                        open_from: 2.days.ago)
      expect(protocol_subscription.reward_points).to eq 1
      expect(protocol_subscription.possible_reward_points).to eq 2
      expect(protocol_subscription.max_reward_points).to eq 3
      visit responseobj.invitation_url(false)
      # expect(page).to have_http_status(200)
      fill_out_questionnaire
      # expect(page).to have_http_status(200)
      expect(page).to have_content('Bedankt voor het invullen van de vragenlijst!')
      protocol_subscription.reload
      expect(protocol_subscription.reward_points).to eq 2
      expect(protocol_subscription.possible_reward_points).to eq 2
      expect(protocol_subscription.max_reward_points).to eq 3
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
      FactoryBot.create(:response,
                        protocol_subscription: protocol_subscription,
                        open_from: 1.hour.ago,
                        invited_state: Response::SENT_STATE)
    end

    let!(:completed_responseobj) do
      FactoryBot.create(:response, :completed,
                        protocol_subscription: protocol_subscription,
                        open_from: 2.days.ago)
    end

    let!(:invitation_token) { FactoryBot.create(:invitation_token, response: responseobj) }

    it 'should not show rewards for Mentors, and it should redirect back to the webapp' do
      expect(protocol_subscription.reward_points).to eq 1
      expect(protocol_subscription.possible_reward_points).to eq 2
      expect(protocol_subscription.max_reward_points).to eq 2
      visit responseobj.invitation_url(false)
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
      expect(protocol_subscription.reward_points).to eq 2
      expect(protocol_subscription.possible_reward_points).to eq 2
      expect(protocol_subscription.max_reward_points).to eq 2
      expect(page).not_to have_content('Je hebt hiermee €1,- verdiend.')
      expect(page).not_to have_content('Je hebt nu in totaal')
      expect(page).not_to have_content('euro')
      expect(page).not_to have_content('€')
      expect(page).not_to have_content('Het onderzoek is voor 67% voltooid. Er is nog €1,- te verdienen.')
    end
  end
end
