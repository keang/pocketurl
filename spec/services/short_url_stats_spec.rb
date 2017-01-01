require 'rails_helper'

RSpec.describe ShortUrlStats do
  before { stub_request(:head, "https://original.com") }

  let(:short_url) { ShortUrl.create(original_url: "https://original.com") }
  let(:visits) { create_list(:visit, 42, short_url_id: short_url.id) }

  describe "#visits_summary" do
    subject { described_class.send(:visits_summary, visits) }

    it "returns the visit count and unique_devices count" do
      expect(subject).to match (
        {
          count: 42,
          unique_devices_count: visits.pluck(:uid).uniq.count
        }
      )
    end
  end

  describe "#devices_data" do
    subject { described_class.send(:devices_data, visits) }

    it "returns the visit count and unique_devices count" do
      expect(subject).to all( include(ips: be_an(Array)).
                             and include(user_agents: be_an(Array)).
                             and include(referrers: be_an(Array))
                            )
    end
  end
end
