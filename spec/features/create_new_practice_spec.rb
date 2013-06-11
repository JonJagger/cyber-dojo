require 'spec_helper'

feature "Start a practice" do
  scenario "Practice doesn't exist yet" do
    visit "/"

    find('#setup').click
    find('#language_ruby_rspec').click
    find('#ok').click
    find('#start_coding').click
    click_button('ok')

    new_window = page.driver.browser.window_handles.last

    page.within_window new_window do
      page.should have_text 'cyber-dojo.sh'
    end

  end
end