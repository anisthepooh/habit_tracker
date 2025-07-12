class WelcomeNotification < ApplicationNotifier
  deliver_by :email, mailer: "UserMailer", method: "welcome_email"

  required_param :user

  def message
    "Welcome to our platform!"
  end

  def url
    root_url
  end
end
