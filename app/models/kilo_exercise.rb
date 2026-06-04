class KiloExercise < ApplicationRecord
  belongs_to :user, optional: true

  has_many :session_exercises, dependent: :restrict_with_error
  has_many :primary_pairings, class_name: "KiloExercisePairing", foreign_key: :primary_exercise_id
  has_many :paired_pairings, class_name: "KiloExercisePairing", foreign_key: :paired_exercise_id

  enum :rotation_group, { press_oh_flat: 0, press_incline_dip: 1, pull_vertical: 2, pull_horizontal: 3 }

  # Matches a YouTube video ID (11 chars) from watch, share, embed, or shorts URLs.
  YOUTUBE_ID_REGEX = %r{(?:youtu\.be/|youtube\.com/(?:watch\?(?:.*&)?v=|embed/|shorts/|v/))([A-Za-z0-9_-]{11})}

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validate :video_url_must_be_youtube

  scope :kilo_standard, -> { where(custom: false) }
  scope :custom_for, ->(user) { where(custom: true, user: user) }
  scope :available_for, ->(user) { where(custom: false).or(where(custom: true, user: user)) }

  # Extracts the YouTube video ID from a watch/share/embed/shorts URL, or nil.
  def self.youtube_id(url)
    return nil if url.blank?

    match = url.to_s.match(YOUTUBE_ID_REGEX)
    match && match[1]
  end

  # Coaches may edit/delete only their own custom exercises. Standard KILO
  # exercises and other coaches' customs are read-only.
  def editable_by?(user)
    custom? && user_id.present? && user_id == user&.id
  end

  private

  # A demo URL is optional, but if present it must be a recognizable YouTube
  # link so the thumbnail and embed helpers can render it.
  def video_url_must_be_youtube
    return if video_url.blank?
    return if self.class.youtube_id(video_url).present?

    errors.add(:video_url, "must be a YouTube link (e.g. https://youtu.be/VIDEO_ID)")
  end
end
