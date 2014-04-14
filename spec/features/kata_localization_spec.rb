# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

feature "kata localization:" do

  before(:each) do
    visit '/?locale=fr'
    find('#setup_button').click
    find('[data-language="Ruby-Rspec"]').click
    find('#ok').click
    find('#start_button').click
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
      page.should have_text 'revenir'   # revert
      page.should have_text 'bifurquer' # fork
    end
  end

end