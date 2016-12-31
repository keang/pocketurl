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

  it "should show the shortened url" do
    expect(page).to have_content full_url_for(ShortUrl.last)
  end
end
