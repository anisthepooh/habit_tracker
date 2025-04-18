class Habit < ApplicationRecord
  has_many :entries, dependent: :destroy

  def calculate_streak
    return 0 if entries.empty?

    latest = entries.first

    # If the latest entry is older than 24 hours from now, streak is broken
    return 0 if Time.current - latest.created_at > 24.hours

    streak = 1
    previous_time = latest.created_at

    entries.offset(1).each do |entry|
      time_diff = previous_time - entry.created_at

      if time_diff <= 24.hours
        streak += 1
        previous_time = entry.created_at
      else
        break
      end
    end

    streak
  end
end
