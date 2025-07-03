class HabitReminderNotification < ApplicationNotifier
  deliver_by :email, mailer: 'HabitReminderMailer', method: 'reminder_email', if: :email_notifications?

  def email_params
    { habit: params[:habit], user: params[:user] }
  end

  def email_notifications?(_notification)
    !!params[:user] # Ensure user is present before sending
  end
  
  # Future: Add push notification delivery
  # deliver_by :web_push, class: 'WebPushDeliveryMethod'
  
  def message
    "Don't forget to complete your habit: #{params[:habit].name}"
  end
  
  def title
    "Habit Reminder"
  end
  
  def habit
    params[:habit]
  end
end