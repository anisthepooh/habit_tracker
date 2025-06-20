class HabitReminderNotification < ApplicationNotifier
  deliver_by :email, mailer: 'HabitReminderMailer', method: 'reminder_email', params: ->(notification) { { habit: notification.params[:habit], user: notification.params[:user] } }
  
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