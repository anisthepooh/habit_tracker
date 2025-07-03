class Habit < ApplicationRecord
  include PublicActivity::Model
  tracked only: [ :create ]

  has_many :entries, dependent: :destroy
  belongs_to :group

  STATUS = [ "active", "succeeded", "failed", "archived" ].freeze
  DONE = %W[succeeded archived]

  # Reminder functionality
  validates :reminder_time, presence: true, if: :reminder_enabled?
  validates :reminder_timezone, presence: true, if: :reminder_enabled?

  # JSON serialization for reminder channels
  serialize :reminder_channels, coder: JSON

  # Scopes for reminder processing
  scope :with_reminders_enabled, -> { where(reminder_enabled: true) }
  scope :needing_reminders, -> { with_reminders_enabled.where.not(reminder_time: nil) }

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

  # Reminder helper methods
  def should_send_reminder?
    return false unless reminder_enabled?
    return false unless reminder_time.present?
    return false if last_reminder_sent_at&.today?
    return false if status == "archived"

    user_timezone = reminder_timezone.presence || group.users.first&.timezone || "UTC"
    current_time_in_zone = Time.current.in_time_zone(user_timezone)

    # Check if current time is within 5 minutes of reminder time
    reminder_hour = reminder_time.hour
    reminder_min = reminder_time.min

    current_time_in_zone.hour == reminder_hour &&
      (current_time_in_zone.min - reminder_min).abs <= 5
  end

  def reminder_channels_list
    reminder_channels || [ "email" ]
  end

  def user
    group.users.first # Assuming single user per group for now
  end

  # Completion methods for habit resume feature
  def completed?
    Date.current >= end_date
  end

  def completion_rate
    return 0 if total_days <= 0
    ((entries.count.to_f / total_days) * 100).round(1)
  end

  def completion_summary
    rate = completion_rate
    message = case rate
    when 80..100 then "🎉 Excellent work!"
    when 60..79 then "👏 Great job!"
    when 40..59 then "👍 Good effort!"
    else "💪 Keep trying!"
    end

    {
      completion_rate: rate,
      total_entries: entries.count,
      total_days: total_days,
      message: message
    }
  end

  private

  # Get unique dates when entries were made this week
  def weekly_entries
    @weekly_entries ||= entries
      .where(created_at: Date.current.beginning_of_week(:monday)..Date.current.end_of_day)
      .pluck(:created_at)
      .map(&:to_date)
      .uniq
  end

  # Map day number to abbreviation
  def day_abbreviation(wday)
    %w[M Tu W Th F Sa Su][wday - 1]
  end

  # Check if streak is broken (no entry yesterday or today)
  def streak_broken?(latest_date)
    return true if latest_date.nil?
    latest_date < Date.current - 1.day
  end
end
