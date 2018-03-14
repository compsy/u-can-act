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

      # InvitationSets
      expect(page).to have_content('InvitationSets')
      expect(page).to have_link('Download', href: '/admin/invitation_set_export.csv')
      page.all('a', text: 'Download')[2].click
      # expect(page.response_headers['Content-Type']).to eq 'text/csv'
      expected_filename = "invitation_sets_#{Time.zone.now.to_date}.csv"
      # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
      expect(page).to have_css('a[disabled]', count: 3)

      # Questionnaires
      expect(@questionnaire_names.size).to eq 3
      expect(page).to have_link('Definition', count: @questionnaire_names.size)
      expect(page).to have_link('Responses', count: @questionnaire_names.size)
      disabled_count = 3
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

  describe 'team overviews' do
    let(:admin) { FactoryBot.create(:admin) }
    let(:payload) { { sub: admin.auth0_id_string } }

    let!(:org1) { FactoryBot.create(:team, name: 'org1') }
    let!(:org2) { FactoryBot.create(:team, name: 'org2') }

    let!(:role1) {  FactoryBot.create(:role, team: org1, group: Person::STUDENT, title: 'Student') }
    let!(:role2) {  FactoryBot.create(:role, team: org1, group: Person::MENTOR, title: 'Mentor') }

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

    before :each do
      basic_auth 'admin', 'admin', '/admin'
    end

    describe 'when not loggedin' do
      it 'should show a login button when not logged in' do
        visit '/admin'
        expect(page).to have_content 'Log In'
      end

      it 'should not list the correct teams with an incorrect session' do
        FactoryBot.create(:questionnaire, name: 'myquestionnairename', title: 'some title',
                                          content: [{ type: :raw, content: 'questionnaire' }])

        visit '/admin'
        page.execute_script("localStorage.setItem('id_token', 'incorrect')")
        page.execute_script("localStorage.setItem('access_token', 'incorrect')")
        page.execute_script("localStorage.setItem('expires_at', '9999999999999')")
        visit '/admin'

        expect(page).to_not have_content 'Team overview'
        expect(page).to_not have_content org1.name
        expect(page).to_not have_content 'Team'
        expect(page).to_not have_content 'Completed'
        expect(page).to_not have_content 'Completed percentage'
        expect(page).to_not have_content '70% completed questionnaires'
        expect(page).to_not have_content Person::STUDENT
        expect(page).to_not have_content Person::MENTOR
      end
    end

    describe 'when loggedin' do
      before :each do
        token = jwt_auth(payload, false)
        # Duplicate vist /admin in order to get a correct page object, one with localstorage
        visit '/admin'
        page.execute_script("localStorage.setItem('id_token', '#{token}')")
        page.execute_script("localStorage.setItem('access_token', '#{token}')")
        page.execute_script("localStorage.setItem('expires_at', '9999999999999')")
        visit '/admin'
      end

      it 'should show a log out button when logged in' do
        basic_auth 'admin', 'admin', '/admin'
        visit '/admin'
        expect(page).to have_content 'Log Out'
      end

      it 'should list the correct teams' do
        FactoryBot.create(:questionnaire, name: 'myquestionnairename', title: 'some title',
                                          content: [{ type: :raw, content: 'questionnaire' }])
        basic_auth 'admin', 'admin', '/admin'
        visit '/admin'
        expect(page).to have_content 'Team overview'
        expect(page).to have_content org1.name
        expect(page).to have_content 'Team'
        expect(page).to have_content 'Completed'
        expect(page).to have_content 'Completed percentage'
        expect(page).to have_content '≥ 70% completed questionnaires'

        # It should not list org2, because it does not have any roles
        expect(page).to_not have_content org2.name

        expect(page).to have_content Person::STUDENT
        expect(page).to have_content Person::MENTOR
      end
    end
  end
end
