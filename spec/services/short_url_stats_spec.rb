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

    it "returns the ips, user_agents and referrers as a arrays" do
      expect(subject).to all( include(ips: be_an(Array)).
                             and include(user_agents: be_an(Array)).
                             and include(referrers: be_an(Array))
                            )
    end

    context "when there are repeat visits" do
      let!(:visits) { [
        create(:visit, short_url: short_url, uid: 'device1', ip: '0.0.0.1'),
        create(:visit, short_url: short_url, uid: 'device1', ip: '0.0.0.1', referrer: "https://example.blog"),
        create(:visit, short_url: short_url, uid: 'device1', ip: '0.0.0.2'),
      ] }

      it "returns only unique ips, user_agents and referrers" do
        expect(subject.count).to eq 1             # only 1 device recorded: device1
        expect(subject.first).to match ({
          uid: "device1",
          ips: ['0.0.0.1', '0.0.0.2'],            # only unique ips
          referrers: [nil, "https://example.blog"],            # only unique ips
          user_agents: ['SOME_USERAGENT_STRING']  # only unique user_agent strings
        })
      end
    end
  end
end
