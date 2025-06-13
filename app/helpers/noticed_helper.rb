module NoticedHelper
  NOTIFICATION_CONFIG = {
    "WelcomeNotification" => {
      icon: "mail",
      delivery_method: "Email",
      type: "Welcome email"
    },
    "HabitReminderNotification" => {
      icon: "bell",
      delivery_method: "Push notification",
      type: "Habit reminder"
    }
  }.freeze

  def notification_icon(notification, css_class: "w-4 h-4 text-gray-600")
    config = notification_config(notification)
    icon_name = config[:icon] || "message-circle"
    lucide_icon(icon_name, class: css_class)
  end

  def notification_delivery_method(notification)
    config = notification_config(notification)
    config[:delivery_method] || notification.type.demodulize.humanize
  end

  def notification_type(notification)
    config = notification_config(notification)
    config[:type] || notification.type.demodulize.humanize
  end

  private

  def notification_config(notification)
    @notification_configs ||= {}
    @notification_configs[notification.type] ||= NOTIFICATION_CONFIG[notification.type.demodulize] || {}
  end
end
