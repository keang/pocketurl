require 'rails_helper'

RSpec.describe 'api/v1/short_urls requests' do
  before { stub_request(:any, "https://original.com") }

  let(:short_url) { ShortUrl.create(original_url: "https://original.com") }
  let!(:visits) { create_list(:visit, rand(100), short_url: short_url) }

  it "returns the stats about the queried short_url" do
    get api_v1_short_url_path, params: { short_path: short_url.short_path }
    expect(response).to be_ok

    response_hash = JSON.parse(response.body)
    expected_hash = {
      "short_path" => short_url.short_path,
      "original_url" => short_url.original_url,
      "visits" => {
        "count" => visits.count,
        "unique_devices_count" => visits.pluck(:uid).uniq.count
      },
      "devices" => be_an(Array)
    }
    expect(response_hash).to match(expected_hash)
  end

  it "returns 404 error if short_url is not found"
end
