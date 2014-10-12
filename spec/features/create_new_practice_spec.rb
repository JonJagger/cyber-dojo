# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

# this is a huge badass feature test that verifies everything at once
feature "Create a practice" do

  scenario "Practice doesn't exist yet" do
    visit "/"
    click_on 'create' #practice
    language('Ruby-Rspec').click
    exercise('Bowling_Game').click
    click_on 'ok'

    click_on 'enter' #practice
    click_on 'ok' #your animal is [cheetah, ...]

    new_window = page.driver.browser.window_handles.last
    page.within_window new_window do
      within '#filename-list' do
        page.should have_text 'cyber-dojo.sh'
        page.should have_text 'instructions'
        page.should have_text 'hiker.rb'
        page.should have_text 'hiker_spec.rb'
      end
    end
  end
end

def language(language_to_select)
  find("[data-language=\"#{language_to_select}\"]")
end

def exercise exercise_to_select
  find("[data-exercise=\"#{exercise_to_select}\"]")
end

