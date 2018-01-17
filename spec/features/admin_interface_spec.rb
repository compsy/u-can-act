# frozen_string_literal: true

require 'rails_helper'

describe 'GET /admin', type: :feature, js: true do
  context 'exporter' do
    before do
      @questionnaire_names = ['my_name',
                              'second_name',
                              'hey I have spaces dagboek 5x per week dinsdag, woensdag, vrijdag']
      @questionnaire_names.each do |questionnaire_name|
        FactoryBot.create(:questionnaire, name: questionnaire_name)
      end
    end

    it 'should have content HTTP Basic: Access denied. when not authorized' do
      visit '/admin'
      expect(page).to have_content('HTTP Basic: Access denied.')
    end

    it 'should be able to download questionnaires correctly' do
      basic_auth 'admin', 'admin', '/admin'
      visit '/admin'

      # People
      expect(page).to have_content('People')
      expect(page).not_to have_css('a[disabled]')
      expect(page).to have_link('Download', href: '/admin/person_export.csv')
      page.all('a', text: 'Download')[0].click
      # expect(page.response_headers['Content-Type']).to eq 'text/csv'
      expected_filename = "people_#{Time.zone.now.to_date}.csv"
      # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
      expect(page).to have_css('a[disabled]', count: 1)

      # ProtocolSubscriptions
      expect(page).to have_content('ProtocolSubscriptions')
      expect(page).to have_link('Download', href: '/admin/protocol_subscription_export.csv')
      page.all('a', text: 'Download')[1].click
      # expect(page.response_headers['Content-Type']).to eq 'text/csv'
      expected_filename = "protocol_subscriptions_#{Time.zone.now.to_date}.csv"
      # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
      expect(page).to have_css('a[disabled]', count: 2)

      # Questionnaires
      expect(@questionnaire_names.size).to eq 3
      expect(page).to have_link('Definition', count: @questionnaire_names.size)
      expect(page).to have_link('Responses', count: @questionnaire_names.size)
      disabled_count = 2
      @questionnaire_names.each_with_index do |questionnaire_name, idx|
        expect(page).to have_content("Questionnaire: #{questionnaire_name}")

        # Definition
        expect(page).to have_link('Definition',
                                  href: "/admin/questionnaire_export/#{questionnaire_name.gsub(' ', '%20')}.csv")
        page.all('a', text: 'Definition')[idx].click
        # expect(page.response_headers['Content-Type']).to eq 'text/csv'
        idified_name = "#{questionnaire_name.parameterize.underscore}_#{Time.zone.now.to_date}"
        expected_filename = "questionnaire_#{idified_name}.csv"
        # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
        disabled_count += 1
        expect(page).to have_css('a[disabled]', count: disabled_count)

        # Responses
        expect(page).to have_link('Responses',
                                  href: "/admin/response_export/#{questionnaire_name.gsub(' ', '%20')}.csv")
        page.all('a', text: 'Responses')[idx].click
        # expect(page.response_headers['Content-Type']).to eq 'text/csv'
        expected_filename = "responses_#{idified_name}.csv"
        # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
        disabled_count += 1
        expect(page).to have_css('a[disabled]', count: disabled_count)
      end
    end
  end

  describe 'questionnaire previews' do
    it 'should have working preview of questionnaires' do
      FactoryBot.create(:questionnaire, name: 'myquestionnairename', title: 'some title',
                                        content: [{ type: :raw, content: 'questionnaire' }])
      basic_auth 'admin', 'admin', '/admin'
      visit '/admin'
      materialize_select('Selecteer een vragenlijst...', 'myquestionnairename')
      page.click_on 'Preview questionnaire'
      expect(page).to have_content 'some title'
      page.click_on 'Opslaan'
      expect(page).to have_content 'Admin Interface'
    end
  end

  describe 'organizational overviews' do
    let!(:org1) { FactoryBot.create(:organization, name: 'org1') }
    let!(:org2) { FactoryBot.create(:organization, name: 'org2') }

    let!(:role1) {  FactoryBot.create(:role, organization: org1, group: Person::STUDENT, title: 'Student') }
    let!(:role2) {  FactoryBot.create(:role, organization: org1, group: Person::MENTOR, title: 'Mentor') }

    let!(:student1) {  FactoryBot.create(:person, :with_protocol_subscriptions, role: role1) }
    let!(:student2) {  FactoryBot.create(:person, :with_protocol_subscriptions, role: role1) }
    let!(:mentor1) { FactoryBot.create(:person, :with_protocol_subscriptions, role: role2) }

    let!(:response1) do
      FactoryBot.create(:response, :completed,
                        open_from: Time.zone.now,
                        protocol_subscription: student1.protocol_subscriptions.first)
    end
    let!(:response2) do
      FactoryBot.create(:response, :completed,
                        open_from: Time.zone.now,
                        protocol_subscription: student2.protocol_subscriptions.first)
    end
    let!(:response3) do
      FactoryBot.create(:response,
                        protocol_subscription: student1.protocol_subscriptions.first)
    end
    let!(:response4) do
      FactoryBot.create(:response,
                        open_from: Time.zone.now + 1.day,
                        protocol_subscription: student2.protocol_subscriptions.first)
    end

    let!(:response5) do
      FactoryBot.create(:response, :completed,
                        open_from: Time.zone.now,
                        protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response6) do
      FactoryBot.create(:response, :completed,
                        open_from: Time.zone.now,
                        protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response7) do
      FactoryBot.create(:response,
                        open_from: Time.zone.now + 1.day,
                        protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response8) do
      FactoryBot.create(:response,
                        protocol_subscription: mentor1.protocol_subscriptions.first)
    end

    it 'should list the correct organizations' do
      FactoryBot.create(:questionnaire, name: 'myquestionnairename', title: 'some title',
                                        content: [{ type: :raw, content: 'questionnaire' }])
      basic_auth 'admin', 'admin', '/admin'
      visit '/admin'
      expect(page).to have_content 'Organization overview'
      expect(page).to have_content org1.name
      expect(page).to have_content 'Organization'
      expect(page).to have_content 'Completed (past week)'
      expect(page).to have_content 'Completed percentage (past week)'

      # It should not list org2, because it does not have any roles
      expect(page).to_not have_content org2.name

      expect(page).to have_content Person::STUDENT
      expect(page).to have_content Person::MENTOR
    end

    it 'should show the current week' do
      Timecop.freeze(2017, 12, 11)
      FactoryBot.create(:questionnaire, name: 'myquestionnairename', title: 'some title',
                                        content: [{ type: :raw, content: 'questionnaire' }])
      basic_auth 'admin', 'admin', '/admin'
      visit '/admin'
      expect(page).to have_content 'Voor week'
      expect(page).to have_content '50'
      Timecop.return
    end
  end
end
