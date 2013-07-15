# encoding: utf-8
require 'spec_helper'

feature "kata localization:" do
  before(:each) do
    visit '/?locale=fr'
    find('#setup').click
    find('#language_ruby_rspec').click
    find('#ok').click
    find('#start_coding').click
    click_button('ok')

    @kata_window = page.driver.browser.window_handles.last
  end

  scenario "aside is localized" do
    page.within_window @kata_window do

      within '#filename_list' do
        page.should have_text 'cyber-dojo.sh'
        page.should have_text 'instructions'
        page.should have_text 'untitled.rb'
        page.should have_text 'untitled_spec.rb'
      end

      within '#file_operations' do
        page.should have_text 'neuf'
        page.should have_text 'renommer'
        page.should have_text 'effacer'
      end

      page.should have_text 'aide'
      page.should have_text 'renommer'
      page.should have_text 'réactions'

    end
  end
end