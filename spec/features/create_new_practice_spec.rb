require 'spec_helper'

# this is a huge badass feature test that verifies everyting at once
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
      within '#filename_list' do
        page.should have_text 'cyber-dojo.sh'
        page.should have_text 'instructions'
        page.should have_text 'untitled.rb'
        page.should have_text 'untitled_spec.rb'
      end
    end

  end
end