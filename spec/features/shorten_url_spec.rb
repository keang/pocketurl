require 'rails_helper'

RSpec.describe 'shorten url' do
  subject do
    visit root_path
    fill_in "URL", with: "https://www.google.com"
    click_on "Shorten"
  end

  before do
    subject
  end

  it "should show the shortened url" do
    expect(page).to have_content full_url_for(ShortUrl.last)
  end
end
