require 'spec_helper'

feature "Start a practice" do
  scenario "Practice doesn't exist yet" do
    visit "/"

    find('#setup').click
    find('#language_ruby_rspec').click
    find('#ok').click
    find('#start_coding').click
    click_button('ok')

    page.should have_text 'cyber-dojo.sh'

  end
end