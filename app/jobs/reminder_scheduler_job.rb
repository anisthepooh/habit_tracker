class ReminderSchedulerJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Starting reminder scheduler job at #{Time.current}"
    
    # Find all habits that need reminders checked
    habits_to_check = Habit.needing_reminders
                           .where(status: ['active', nil]) # Only active habits
                           .includes(:group)
    
    Rails.logger.info "Found #{habits_to_check.count} habits with reminders enabled"
    
    reminders_queued = 0
    
    habits_to_check.find_each do |habit|
      if habit.should_send_reminder?
        HabitReminderJob.perform_later(habit.id)
        reminders_queued += 1
        Rails.logger.info "Queued reminder for habit #{habit.id} (#{habit.name})"
      end
    end
    
    Rails.logger.info "Queued #{reminders_queued} habit reminders"
    
    # Schedule the next run in 5 minutes (self-perpetuating cycle)
    ReminderSchedulerJob.set(wait: 5.minutes).perform_later
    Rails.logger.info "Scheduled next ReminderSchedulerJob in 5 minutes"
  end
end