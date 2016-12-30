class ShortUrl < ApplicationRecord
  before_validation :generate_short_path, on: :create
  validates :short_path, presence: true

  validates :original_url, presence: true
  # TODO: breakdown and validate each url components,
  # because the regex can be slow for very long url
  validates_format_of :original_url, :with => /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?/i

  def generate_short_path
    self.short_path = SecureRandom.urlsafe_base64(6)
    generate_short_path if ShortUrl.exists?(short_path: short_path)
  end
end
