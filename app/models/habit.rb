class Habit < ApplicationRecord
  has_many :entries, dependent: :destroy
  belongs_to :group

  STATUS = [ "active", "succeded", "failed" ].freeze

  def end_date
    start_date + duration.days
  end

  def total_days
    (end_date - start_date).to_i
  end

  def elapsed_days
    [ (Date.current - start_date).to_i, total_days ].min
  end

  def time_progress_percentage
    return 0 if total_days <= 0
    ((elapsed_days.to_f / total_days) * 100).clamp(0, 100)
  end

  def update_status
    self.status = if entries.size >= duration
                    "succeeded"
    else
                    "active"
    end
    save if status_changed? # Save if the status actually changed
  end

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
