# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

# this is a huge badass feature test that verifies everything at once
feature "Create a practice" do

  scenario "Practice doesn't exist yet" do
    visit "/"
    find('#create-button').click
    find('[data-language="Ruby-Rspec"]').click
    find('#ok').click
    find('#enter-button').click
    click_button('ok')
    new_window = page.driver.browser.window_handles.last
    page.within_window new_window do
      within '#filename_list' do
        page.should have_text 'cyber-dojo.sh'
        page.should have_text 'instructions'
        page.should have_text 'hiker.rb'
        page.should have_text 'hiker_spec.rb'
      end
    end
  end
end

feature "Practice is full" do

end