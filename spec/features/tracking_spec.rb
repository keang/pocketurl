require 'rails_helper'

RSpec.describe 'tracking' do
  let(:short_url) { ShortUrl.create(original_url: "https://original.com") }

  subject do
    visit short_url.short_path
  end

  before { stub_request(:any, "https://original.com") }

  it "creates a Visit row" do
    expect { subject }.to change { short_url.visits.count }.by 1
  end

  it "creates a cookie named 'user'" do
    subject
    expect(get_me_the_cookie("user")[:value]).to be_present
  end

  it "keeps the same cookie named 'user' if present" do
    create_cookie("user", "existing_uuid")
    subject
    expect(get_me_the_cookie("user")[:value]).to eq "existing_uuid"
  end

end
