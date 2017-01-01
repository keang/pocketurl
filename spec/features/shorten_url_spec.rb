require 'rails_helper'

RSpec.describe 'shorten url' do
  subject do
    visit root_path
    fill_in "URL", with: "https://example.com"
    click_on "Shorten"
  end

  before do
    stub_request(:head, "https://example.com")
    subject
  end

  it "should show the shortened url and stats link" do
    surl = ShortUrl.last
    expect(page).to have_content full_url_for(surl)
    path = api_v1_short_url_path(short_path: surl.short_path)
    expect(page).to have_css("a[href='#{path}']")
  end
end
