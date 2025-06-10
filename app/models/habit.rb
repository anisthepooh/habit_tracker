class Habit < ApplicationRecord
  include PublicActivity::Model
  tracked only: [ :create ]

  has_many :entries, dependent: :destroy
  belongs_to :group

  STATUS = [ "active", "succeeded", "failed", "archived" ].freeze

  # Weekly tracking methods
  def completed_days_this_week
    weekly_entries.group_by(&:wday).keys.map { |wday| day_abbreviation(wday) }
  end

  def entry_made_today?
    weekly_entries.any? { |date| date == Date.current }
  end

  def entries_count_this_week
    weekly_entries.count
  end

  # Existing methods...
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
    self.status = Date.current > end_date ? "succeeded" : "active"
    save if status_changed?
  end

  def calculate_streak
    return 0 if entries.empty?

    sorted_dates = entries.order(created_at: :desc).pluck(:created_at).map(&:to_date).uniq
    return 0 if streak_broken?(sorted_dates.first)

    sorted_dates.each_cons(2).with_index(1) do |(current, previous), streak|
      return streak if (previous - current).to_i > 1
    end

    sorted_dates.count
  end

  private

  # Get unique dates when entries were made this week
  def weekly_entries
    @weekly_entries ||= entries
      .where(created_at: Date.current.beginning_of_week(:sunday)..Date.current.end_of_day)
      .pluck(:created_at)
      .map(&:to_date)
      .uniq
  end

  # Map day number to abbreviation
  def day_abbreviation(wday)
    %w[Su M Tu W Th F Sa][wday]
  end

  # Check if streak is broken (no entry yesterday or today)
  def streak_broken?(latest_date)
    return true if latest_date.nil?
    latest_date < Date.current - 1.day
  end
end
