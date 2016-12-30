require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  describe "creating new record" do
    subject { ShortUrl.create!(original_url: "https://example.com") }

    it { expect(subject).to be_persisted }
    it { expect(subject.short_path).to match(/([A-Za-z0-9\-_]){6}/) }

    context "SecureRandom collides" do
      let(:existing_short_url) { ShortUrl.create(original_url: "https://example.com",
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
      valid_urls = ["example.com",
                    "https://example.com/abc?as#test",
                    "https://goo.gl/maps/GFjztXL2",
                    "http://example.io"]
      invalid_urls = ["postgres://example.com",
                      "https://.com",
                      "http://example"]

      valid_urls.each do |url|
        it "does not raise validation error for #{url}" do
          expect {
            ShortUrl.create!(original_url: url)
          }.not_to raise_error
        end
      end

      invalid_urls.each do |url|
        it "raises validation error for #{url}" do
          expect {
            ShortUrl.create!(original_url: url)
          }.to raise_error ActiveRecord::RecordInvalid
        end
      end

    end
  end
end
