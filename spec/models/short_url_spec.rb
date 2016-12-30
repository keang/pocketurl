require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  describe "creating new ShortUrl" do
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
  end
end
