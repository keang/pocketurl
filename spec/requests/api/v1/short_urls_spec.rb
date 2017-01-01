require 'rails_helper'

RSpec.describe 'api/v1/short_urls requests' do
  before { stub_request(:any, "https://original.com") }

  let(:short_url) { ShortUrl.create(original_url: "https://original.com") }
  let!(:visits) { create_list(:visit, rand(100), short_url: short_url) }
  let(:expected_hash) { {
    "short_path" => short_url.short_path,
    "original_url" => short_url.original_url,
    "visits" => {
      "count" => visits.count,
      "unique_devices_count" => visits.pluck(:uid).uniq.count
    },
    "devices" => be_an(Array)  # See detailed specs at spec/services/short_url_stats_spec.rb
  } }

  it "returns the stats when queried by short_path" do
    get api_v1_short_url_path, params: { short_path: short_url.short_path }
    expect(response).to be_ok

    response_hash = JSON.parse(response.body)
    expect(response_hash).to match(expected_hash)
  end

  it "returns the stats when queried by original_url" do
    get api_v1_short_url_path, params: { original_url: short_url.original_url }
    expect(response).to be_ok

    response_hash = JSON.parse(response.body)
    expect(response_hash).to match(expected_hash)
  end


  it "returns 404 error if short_url is not found" do
    expect {
      get api_v1_short_url_path, params: { original_url: "https://non-existent.com" }
    }.to raise_error ActiveRecord::RecordNotFound
  end
end
