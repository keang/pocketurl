require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  let(:url_200) { "https://example.com/200" }
  before { stub_request(:head, url_200).to_return(status: 200) }

  describe "creating new record" do
    subject { ShortUrl.create!(original_url:url_200) }

    it { expect(subject).to be_persisted }
    it { expect(subject.short_path).to match(/([A-Za-z0-9\-_]){6}/) }

    context "SecureRandom collides" do
      let(:existing_short_url) { ShortUrl.create(original_url:url_200,
                                                  short_path: "abcde") }
      before do
        allow(SecureRandom).to receive(:urlsafe_base64).and_return('colliding_string', 'colliding_string', 'new_string')
        expect(existing_short_url.short_path).to eq 'colliding_string'
      end

      it "continues to generate new random token" do
        expect { subject }.to change { ShortUrl.count }.by 1
        expect(ShortUrl.last.short_path).to eq "new_string"
      end
    end

    describe "original_url validation" do
      it "invalidates with response 500" do
        url_500 = "https://example.com/500"
        stub_request(:head, url_500).to_return(status: 500)
        short_url = ShortUrl.new(original_url: url_500)
        expect(short_url).to_not be_valid
        expect(short_url.errors).to_not be_empty
      end
    end
  end
end
