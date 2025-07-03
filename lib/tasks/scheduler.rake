namespace :scheduler do
  desc "Start the reminder scheduler job"
  task start: :environment do
    # Ensure the job isn't already scheduled
    if !SolidQueue::ScheduledExecution.exists?(job_name: "ReminderSchedulerJob")
      ReminderSchedulerJob.perform_later
      puts "Reminder scheduler job started."
    else
      puts "Reminder scheduler job is already scheduled."
    end
  end
end
