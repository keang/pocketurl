FactoryGirl.define do
  factory :visit do
    ip { Faker::Internet.ip_v4_address }
    user_agent "SOME_USERAGENT_STRING"
    uid { SecureRandom.uuid }
    created_at { rand(10).days.ago }
    short_url { create(:short_url) }
  end
end
