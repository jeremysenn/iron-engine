class ClientShareToken < ApplicationRecord
  belongs_to :client

  before_create :generate_token

  validates :expires_at, presence: true

  scope :active, -> { where(revoked_at: nil).where("expires_at > ?", Time.current) }

  def active?
    revoked_at.nil? && expires_at > Time.current
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64(24)
  end
end
