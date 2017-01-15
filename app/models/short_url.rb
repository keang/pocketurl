class ShortUrl < ApplicationRecord
  before_validation :generate_short_path, on: :create
  before_validation :sanitize_original_url, on: :create
  validates :short_path, presence: true

  validates :original_url, presence: true
  validates_with UrlValidator, field: :original_url

  has_many :visits

  def sanitize_original_url
    self.original_url = Addressable::URI.heuristic_parse(original_url).to_s
  end

  def generate_short_path
    self.short_path = SecureRandom.urlsafe_base64(6)
    generate_short_path if ShortUrl.exists?(short_path: short_path)
  end
end
