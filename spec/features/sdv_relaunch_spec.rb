# frozen_string_literal: true

require 'rails_helper'

describe 'Answers survive an SDV session expiry', type: :feature, js: true do
  let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
  let(:protocol_subscription) do
    FactoryBot.create(:protocol_subscription, person: the_auth_user.person, start_date: 1.week.ago)
  end
  let(:questionnaire) do
    FactoryBot.create(:questionnaire, content: { questions: [
                        { id: :v1, type: :radio, title: 'Hoe voelt u zich vandaag?', options: %w[slecht goed] },
                        { id: :v2, type: :textarea, title: 'Wat wilt u nog kwijt?' }
                      ], scores: [] })
  end
  let(:responseobj) do
    FactoryBot.create(:response, :invited, protocol_subscription: protocol_subscription, open_from: 10.minutes.ago,
                                           measurement: FactoryBot.create(:measurement, questionnaire: questionnaire))
  end

  def set_platform_cookie
    token = jwt_auth({ 'sub' => the_auth_user.auth0_id_string, 'exp' => 5.minutes.from_now.to_i }, false)
    page.driver.browser.manage.add_cookie(name: SdvLaunchController::PLATFORM_SESSION_COOKIE, value: "Bearer #{token}")
  end

  def answer_backups
    page.evaluate_script("Object.keys(sessionStorage).filter(function (k) { return k.indexOf('answer_backup_') === 0 }).length")
  end

  def launch_and_fill_in
    visit '/status'
    set_platform_cookie
    visit "/sdv/launch?return_to=/questionnaire/#{responseobj.uuid}"
    expect(page).to have_content('Hoe voelt u zich vandaag?')
    page.choose('slecht', allow_label_click: true)
    page.fill_in('v2', with: 'Halverwege ingevuld')
  end

  it 'restores the answers after the relaunch and stores them on the next submit' do
    launch_and_fill_in
    expect(answer_backups).to eq 0

    Timecop.travel(10.minutes.from_now)
    set_platform_cookie
    page.execute_script("$('body').append('<div id=\"before-relaunch\"></div>')")
    page.find('button[type=submit]').click

    expect(page).to have_no_css('#before-relaunch')
    expect(page).to have_current_path("/questionnaire/#{responseobj.uuid}")
    expect(page).to have_checked_field('slecht', visible: :all)
    expect(page).to have_field('v2', with: 'Halverwege ingevuld')
    expect(responseobj.reload.completed_at).to be_nil
    expect(answer_backups).to eq 0

    page.find('button[type=submit]').click
    expect(page).not_to have_current_path("/questionnaire/#{responseobj.uuid}")
    expect(responseobj.reload.completed_at).to be_present
    expect(responseobj.values).to include('v1' => 'slecht', 'v2' => 'Halverwege ingevuld')
    expect(answer_backups).to eq 0
  end

  it 'keeps no answers in the browser after a submit with a valid session' do
    launch_and_fill_in
    page.find('button[type=submit]').click

    expect(page).to have_current_path('/klaar')
    expect(responseobj.reload.completed_at).to be_present
    expect(answer_backups).to eq 0
  end

  it 'clears answer backups on the done page' do
    launch_and_fill_in
    page.find('button[type=submit]').click
    expect(page).to have_current_path('/klaar')

    page.execute_script("sessionStorage.setItem('answer_backup_#{responseobj.id}', '{}')")
    visit '/klaar'
    expect(page).to have_css('[data-clear-answer-backup]', visible: :all)
    expect(answer_backups).to eq 0
  end
end
