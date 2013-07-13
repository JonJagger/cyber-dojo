# encoding: utf-8
require "spec_helper"

feature "localization:" do
  before(:each) do
    visit "/?locale=fr"
  end

  scenario "home page is localized" do
    page.should have_text "créer"
  end

  scenario "home page remembers locale" do
    visit "/"
    page.should have_text "créer"
  end

  scenario "about page is localized" do
    find("#about").click
    page.should_not have_text "about"
    page.should have_text "Le Cyber-Dojo"
  end
end