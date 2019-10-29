# frozen_string_literal: true

describe 'static_pages', type: :feature do
  it 'has a valid disclaimer page' do
    page_title = 'Disclaimer'
    visit disclaimer_path
    expect(page).to have_content(page_title)
  end
end
