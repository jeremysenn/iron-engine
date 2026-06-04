require "test_helper"

class KiloExerciseTest < ActiveSupport::TestCase
  # ── YouTube ID extraction ──────────────────────────────────────────────
  test "youtube_id extracts the id from common YouTube URL formats" do
    {
      "https://youtu.be/_-KjNA_grKI"                   => "_-KjNA_grKI",
      "https://www.youtube.com/watch?v=dQw4w9WgXcQ"    => "dQw4w9WgXcQ",
      "https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=30s" => "dQw4w9WgXcQ",
      "https://youtube.com/embed/dQw4w9WgXcQ"          => "dQw4w9WgXcQ",
      "https://www.youtube.com/shorts/dQw4w9WgXcQ"     => "dQw4w9WgXcQ",
      "https://youtu.be/dQw4w9WgXcQ?si=abc123"         => "dQw4w9WgXcQ"
    }.each do |url, expected|
      assert_equal expected, KiloExercise.youtube_id(url), "failed for #{url}"
    end
  end

  test "youtube_id returns nil for blank or non-YouTube URLs" do
    assert_nil KiloExercise.youtube_id(nil)
    assert_nil KiloExercise.youtube_id("")
    assert_nil KiloExercise.youtube_id("https://vimeo.com/12345")
    assert_nil KiloExercise.youtube_id("not a url")
  end

  # ── video_url validation ───────────────────────────────────────────────
  test "is valid with a blank video_url" do
    exercise = KiloExercise.new(name: "No Demo", custom: true)
    assert exercise.valid?, exercise.errors.full_messages.to_sentence
  end

  test "is valid with a YouTube video_url" do
    exercise = KiloExercise.new(name: "With Demo", custom: true, video_url: "https://youtu.be/dQw4w9WgXcQ")
    assert exercise.valid?, exercise.errors.full_messages.to_sentence
  end

  test "is invalid with a non-YouTube video_url" do
    exercise = KiloExercise.new(name: "Bad Demo", custom: true, video_url: "https://vimeo.com/12345")
    assert_not exercise.valid?
    assert_includes exercise.errors[:video_url], "must be a YouTube link (e.g. https://youtu.be/VIDEO_ID)"
  end
end
