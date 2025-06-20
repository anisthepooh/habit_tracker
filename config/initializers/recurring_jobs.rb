# Recurring Jobs Configuration
# This sets up the reminder scheduler job to run periodically

Rails.application.configure do
  config.after_initialize do
    # Only run in non-test environments and when database is available
    unless Rails.env.test?
      begin
        # Check if the database is available and has the required tables
        ActiveRecord::Base.connection.execute("SELECT 1 FROM solid_queue_jobs LIMIT 1")
        
        # Schedule the first reminder job to start the recurring cycle
        ReminderSchedulerJob.set(wait: 1.minute).perform_later
        Rails.logger.info "Scheduled initial ReminderSchedulerJob"
      rescue ActiveRecord::StatementInvalid, ActiveRecord::NoDatabaseError => e
        # Database not ready or tables don't exist (e.g., during assets:precompile)
        Rails.logger.info "Skipping job scheduling - database not ready: #{e.message}"
      end
    end
  end
end