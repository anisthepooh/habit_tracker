# frozen_string_literal: true

#
class StreakWeekDaysComponent < ViewComponent::Base
  def initialize(habit:)
    @habit = habit
  end

  private

  attr_reader :habit

  def streak_count
    habit.calculate_streak
  end

  def completed_days
    habit.completed_days_this_week
  end

  def days_of_week
    %w[M Tu W Th F Sa Su ]
  end

  def day_completed?(day)
    completed_days.include?(day)
  end
end
