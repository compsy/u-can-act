# frozen_string_literal: true

describe 'status', type: :feature do
  it 'should return OK' do
    visit status_path
    expect(page).to have_content('OK')
  end
end
