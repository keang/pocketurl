class ShortUrl < ApplicationRecord
  validates :original_url, presence: true
  validates :short_path, presence: true
  before_validation :generate_short_path, on: :create

  def generate_short_path
    self.short_path = SecureRandom.urlsafe_base64(6)
    generate_short_path if ShortUrl.exists?(short_path: short_path)
  end
end
