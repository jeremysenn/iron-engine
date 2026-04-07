class KiloTrainingSplit < ApplicationRecord
  enum :goal, { hypertrophy: 0, absolute_strength: 1, relative_strength: 2, power: 3 }
  enum :phase, { accumulation: 0, intensification: 1 }
  enum :training_level, { novice: 0, intermediate: 1, advanced: 2 }

  validates :goal, presence: true
  validates :phase, presence: true
  validates :training_level, presence: true
  validates :frequency, presence: true, inclusion: { in: 2..6 }
  validates :name, presence: true

  # Human-readable session type labels for display
  SESSION_TYPE_LABELS = {
    "upper_body_1" => "Upper Body 1", "upper_body_2" => "Upper Body 2", "upper_body_3" => "Upper Body 3",
    "lower_body_1" => "Lower Body 1", "lower_body_2" => "Lower Body 2",
    "full_body_1" => "Full Body 1", "full_body_2" => "Full Body 2",
    "session_1" => "Session 1", "session_2" => "Session 2", "session_3" => "Session 3",
    "chest_and_back" => "Chest & Back", "arms_and_shoulders" => "Arms & Shoulders",
    "lower_body" => "Lower Body", "posterior_chain" => "Posterior Chain",
    "chest_and_arms" => "Chest & Arms", "back_and_shoulders" => "Back & Shoulders",
    "chest" => "Chest", "back" => "Back"
  }.freeze

  DAY_LABELS = { "mon" => "Mon", "tue" => "Tue", "wed" => "Wed", "thu" => "Thu",
                 "fri" => "Fri", "sat" => "Sat", "sun" => "Sun" }.freeze

  def session_type_summary
    struct = split_structure.is_a?(String) ? JSON.parse(split_structure) : split_structure
    struct.map { |day, st| "#{DAY_LABELS[day]}: #{SESSION_TYPE_LABELS[st] || st.titleize}" }.join(" / ")
  end

  def display_label
    "#{name} — #{frequency}x/wk"
  end

  def display_label_with_days
    struct = split_structure.is_a?(String) ? JSON.parse(split_structure) : split_structure
    short_types = struct.map { |day, st| SESSION_TYPE_LABELS[st]&.gsub(/ \d+$/, "") || st.titleize }
    "#{name} — #{frequency}x/wk (#{short_types.uniq.join(", ")})"
  end
end
