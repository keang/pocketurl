require 'rails_helper'

RSpec.describe 'tracking' do
  let(:short_url) { ShortUrl.create(original_url: "https://example.com") }

  subject do
    visit short_url.short_path
  end

  before { stub_request(:any, short_url.original_url) }

  it "creates a Visit row" do
    expect { subject }.to change { short_url.visits.count }.by 1
  end

end
