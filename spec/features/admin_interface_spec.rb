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

    it 'has content HTTP Basic: Access denied. when not authorized' do
      visit '/admin'
      expect(page).to have_content('HTTP Basic: Access denied.')
    end

    describe 'should have the correct menu items' do
      before do
        basic_auth 'admin', 'admin', '/admin'
      end

      it 'has a dashboard entry' do
        expect(page).to have_link('Dashboard', href: '/admin')
      end
      it 'has an export entry' do
        expect(page).to have_link('Exports', href: '/admin/export')
      end
      it 'has a preview entry' do
        expect(page).to have_link('Preview questionnaires', href: '/admin/preview_overview')
      end
      it 'has an organization overview entry' do
        expect(page).to have_link('Organization overview', href: '/admin/organization_overview')
      end
    end

    describe 'Exports' do
      before do
        basic_auth 'admin', 'admin', '/admin'
        page.click_on 'Exports'
        find('ul.collapsible>li:first-child>.collapsible-header').click # fold out the first collapsible thing
      end

      it 'exports people' do
        expect(page).to have_content('People')
        expect(page).not_to have_css('a[disabled]')
        expect(page).to have_link('Download', href: '/admin/person_export.csv')
        page.all('a', text: 'Download')[0].click
        # expect(page.response_headers['Content-Type']).to eq 'text/csv'
        # "people_#{Time.zone.now.to_date}.csv"
        # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
        expect(page).to have_css('a[disabled]', count: 1)
      end

      it 'exports ProtocolSubscriptions' do
        expect(page).to have_content('ProtocolSubscriptions')
        expect(page).to have_link('Download', href: '/admin/protocol_subscription_export.csv')
        page.all('a', text: 'Download')[1].click
        # expect(page.response_headers['Content-Type']).to eq 'text/csv'
        # expected_filename = "protocol_subscriptions_#{Time.zone.now.to_date}.csv"
        # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
        expect(page).to have_css('a[disabled]', count: 1)
      end

      it 'exports InvitationSets' do
        expect(page).to have_content('InvitationSets')
        expect(page).to have_link('Download', href: '/admin/invitation_set_export.csv')
        page.all('a', text: 'Download')[2].click
        # expect(page.response_headers['Content-Type']).to eq 'text/csv'
        # expected_filename = "invitation_sets_#{Time.zone.now.to_date}.csv"
        # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
        expect(page).to have_css('a[disabled]', count: 1)
      end

      it 'exports ProtocolTransfers' do
        expect(page).to have_content('ProtocolTransfers')
        expect(page).to have_link('Download', href: '/admin/protocol_transfer_export.csv')
        page.all('a', text: 'Download')[3].click
        # expect(page.response_headers['Content-Type']).to eq 'text/csv'
        # expected_filename = "protocol_transfers_#{Time.zone.now.to_date}.csv"
        # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
        expect(page).to have_css('a[disabled]', count: 1)
      end

      it 'exports rewards' do
        expect(page).to have_content('Rewards')
        expect(page).not_to have_css('a[disabled]')
        expect(page).to have_link('Download', href: '/admin/reward_export.csv')
        page.all('a', text: 'Download')[4].click
        # expect(page.response_headers['Content-Type']).to eq 'text/csv'
        # "people_#{Time.zone.now.to_date}.csv"
        # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
        expect(page).to have_css('a[disabled]', count: 1)
      end

      it 'exports rewards' do
        expect(page).to have_content('Proof of participation')
        expect(page).not_to have_css('a[disabled]')
        expect(page).to have_link('Download', href: '/admin/proof_of_participation_export.csv')
        page.all('a', text: 'Download')[5].click
        # expect(page.response_headers['Content-Type']).to eq 'text/csv'
        # "people_#{Time.zone.now.to_date}.csv"
        # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
        expect(page).to have_css('a[disabled]', count: 1)
      end

      it 'exports Questionnaires' do
        expect(@questionnaire_names.size).to eq 3
        expect(page).to have_link('Definition', count: @questionnaire_names.size)
        expect(page).to have_link('Responses', count: @questionnaire_names.size)
        disabled_count = 0
        @questionnaire_names.each_with_index do |questionnaire_name, idx|
          expect(page).to have_content("Questionnaire: #{questionnaire_name}")

          # Definition
          expect(page).to have_link('Definition',
                                    href: "/admin/questionnaire_export/#{questionnaire_name.gsub(' ', '%20')}.csv")
          page.all('a', text: 'Definition')[idx].click
          # expect(page.response_headers['Content-Type']).to eq 'text/csv'
          # idified_name = "#{questionnaire_name.parameterize.underscore}_#{Time.zone.now.to_date}"
          # expected_filename = "questionnaire_#{idified_name}.csv"
          # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
          disabled_count += 1
          expect(page).to have_css('a[disabled]', count: disabled_count)

          # Responses
          expect(page).to have_link('Responses',
                                    href: "/admin/response_export/#{questionnaire_name.gsub(' ', '%20')}.csv")
          page.all('a', text: 'Responses')[idx].click
          # expect(page.response_headers['Content-Type']).to eq 'text/csv'
          # expected_filename = "responses_#{idified_name}.csv"
          # expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
          disabled_count += 1
          expect(page).to have_css('a[disabled]', count: disabled_count)
        end
      end
    end
  end

  describe 'Preview questionnaires' do
    let!(:questionnaire) do
      FactoryBot.create(:questionnaire, name: 'myquestionnairename', title: 'some title',
                                        content: { questions: [{ type: :raw, content: 'questionnaire' }], scores: [] })
    end

    before do
      basic_auth 'admin', 'admin', '/admin'
      page.click_on 'Preview questionnaires'
    end

    it 'has working preview of questionnaires' do
      materialize_select('Select a questionnaire...', 'myquestionnairename')
      page.click_on 'Preview questionnaire'
      expect(page).to have_content 'some title'
      page.click_on 'Opslaan'
      expect(page).to have_content 'Preview questionnaires'
    end
  end

  describe 'Organization overview' do
    let(:auth_user) { FactoryBot.create(:auth_user, :admin) }
    let(:payload) { { sub: auth_user.auth0_id_string } }

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
                        open_from: 1.day.from_now,
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
                        open_from: 1.day.from_now,
                        protocol_subscription: mentor1.protocol_subscriptions.first)
    end
    let!(:response8) do
      FactoryBot.create(:response,
                        protocol_subscription: mentor1.protocol_subscriptions.first)
    end

    before do
      basic_auth 'admin', 'admin', '/admin'
    end

    describe 'when not loggedin' do
      xit 'shows a login button when not logged in' do
        # TODO: I cannot get this spec to work
        expect(page).to have_content 'Log In'
      end

      it 'shows a message when not logged in' do
        page.click_on 'Organization overview'
        expect(page).to have_content 'You need to authenticate first.'
      end

      it 'does not list the correct teams with an incorrect session' do
        FactoryBot.create(:questionnaire,
                          name: 'myquestionnairename',
                          title: 'some title',
                          content: { questions: [{ type: :raw, content: 'questionnaire' }], scores: [] })

        page.execute_script("localStorage.setItem('id_token', 'incorrect')")
        page.execute_script("localStorage.setItem('access_token', 'incorrect')")
        page.execute_script("localStorage.setItem('expires_at', '9999999999999')")
        page.click_on 'Organization overview'

        expect(page).not_to have_content 'Team overview'
        expect(page).not_to have_content org1.name
        expect(page).not_to have_content 'Team'
        expect(page).not_to have_content 'Completed'
        expect(page).not_to have_content 'Completed percentage'
        expect(page).not_to have_content '70% completed questionnaires'
      end
    end

    describe 'when loggedin' do
      before do
        token = jwt_auth(payload, false)
        # Duplicate vist /admin in order to get a correct page object, one with localstorage
        visit '/admin'
        page.execute_script("localStorage.setItem('id_token', '#{token}')")
        page.execute_script("localStorage.setItem('access_token', '#{token}')")
        page.execute_script("localStorage.setItem('expires_at', '9999999999999')")
        page.click_on 'Organization overview'
      end

      # xit 'shows a log out button when logged in' do # uncomment whn auth is fixed
      #   visit '/admin'
      #   expect(page).to have_content 'Log Out'
      # end
      #
      # xit 'should list the correct teams' do # uncomment when Auth is fixed
      #   Team.overview(bust_cache: true)
      #   FactoryBot.create(:questionnaire, name: 'myquestionnairename', title: 'some title',
      #                                     content: { questions: [{ type: :raw, content: 'questionnaire' }]
      #                                                scores: [] })
      #   page.click_on 'Organization overview'
      #   expect(page).to have_content 'Team overview'
      #   expect(page).to have_content org1.name
      #   expect(page).to have_content 'Team'
      #   expect(page).to have_content 'Completed'
      #   expect(page).to have_content 'Completed percentage'
      #   expect(page).to have_content '70% completed questionnaires'
      #
      #   # It should not list org2, because it does not have any roles
      #   expect(page).not_to have_content org2.name
      #
      #   expect(page).to have_content Person::STUDENT
      #   expect(page).to have_content Person::MENTOR
      # end
    end
  end
end
