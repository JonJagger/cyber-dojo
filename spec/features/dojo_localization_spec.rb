# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

feature "dojo localization:" do

  before(:each) do
    visit '/?locale=fr'
  end

  scenario "home page is localized" do
    page.should have_text 'créer'
  end

  scenario "home page remembers locale" do
    visit '/'
    page.should have_text 'créer'
  end

  scenario "about page is localized" do
    find('#about').click
    page.should_not have_text 'about'
    page.should have_text 'Le Cyber-Dojo'
  end

  scenario "setup page is localized" do
    find('#setup_button').click
    visit '/setup/show?locale=fr'
    page.should have_text 'language?'
    page.should have_text 'exercice?'
    page.should have_text 'ok'
    page.should have_text 'annuler'
    find('#ok').click
    page.should have_text 'créer'
  end
  
end