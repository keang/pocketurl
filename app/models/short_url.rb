class ShortUrl < ApplicationRecord
  validates :original_url, presence: true
  validates :short_path, presence: true, uniqueness: true

  before_validation :generate_short_path, on: :create

  def generate_short_path
    self.short_path = SecureRandom.hex(6) unless short_path
  end
end
