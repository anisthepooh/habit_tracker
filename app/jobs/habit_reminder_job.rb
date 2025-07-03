class HabitReminderJob < ApplicationJob
  queue_as :default

  def perform(habit_id)
    habit = Habit.find_by(id: habit_id)
    return unless habit&.should_send_reminder?

    HabitReminderNotification.with(habit: habit, user: habit.user).deliver(habit.user)

    # Update last reminder sent timestamp
    habit.update!(last_reminder_sent_at: Time.current)
    
    Rails.logger.info "Sent reminder for habit #{habit.id} (#{habit.name}) to #{habit.user.email_address}"
  end
end