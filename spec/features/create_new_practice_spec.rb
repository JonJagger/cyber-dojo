# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

feature "Create new practice" do

  scenario "And enter as an animal" do
    ENV['CYBERDOJO_USE_HOST'] = 'true'
    visit "/"
    click_on 'create'
    language('Ruby-Rspec').click
    exercise('Bowling_Game').click
    click_on 'ok'

    click_on 'enter'
    click_on 'ok' #your animal is [cheetah, ...]

    within_window(windows.last) do
      within '#filename-list' do
        expect(page).to have_text 'cyber-dojo.sh'
        expect(page).to have_text 'instructions'
        expect(page).to have_text 'hiker.rb'
        expect(page).to have_text 'hiker_spec.rb'
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
