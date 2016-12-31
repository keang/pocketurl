require 'rails_helper'
require 'webmock/rspec'

RSpec.describe UrlValidator do

  class TestClass
    attr_accessor :url

    def valid?
      UrlValidator.new(field: :url).validate(self)
    end
  end

  let(:responses_urls) { {
    200 => "https://example.com/200",
    301 => "https://example.com/301",
    302 => "https://example.com/302",
    404 => "https://example.com/404",
    500 => "https://example.com/500"
  } }

  before do
    responses_urls.each do |status_code, url|
      stub_request(:head, url).to_return(status: status_code)
    end
  end

  it "validates 200, 301 and 302 url" do
    record = TestClass.new
    responses_urls.each do |code, url|
      record.url = url
      if [200, 301, 302].include? code
        expect(record).to be_valid
      else
        expect(record).to_not be_valid
      end
    end
  end
end
