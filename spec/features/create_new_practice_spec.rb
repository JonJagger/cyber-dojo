# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

# this is a huge badass feature test that verifies everything at once
feature "Start a practice" do

  scenario "Practice doesn't exist yet" do
    visit "/"
    find('#setup_button').click
    find('[data-language="Ruby-Rspec"]').click
    find('#ok').click
    find('#start_button').click
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

feature "Practice is full" do

end