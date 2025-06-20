# Recurring Jobs Configuration
# This sets up the reminder scheduler job to run periodically

Rails.application.configure do
  config.after_initialize do
    # Only run in non-test environments
    unless Rails.env.test?
      # Schedule the first reminder job to start the recurring cycle
      ReminderSchedulerJob.set(wait: 1.minute).perform_later
      Rails.logger.info "Scheduled initial ReminderSchedulerJob"
    end
  end
end