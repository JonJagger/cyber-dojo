# encoding: utf-8
require "spec_helper"

feature "localization:" do
  before(:each) do
    visit "/?locale=fr"
  end

  scenario "home page remembers locale" do
    visit "/"
    page.should have_text "créer"
  end
end