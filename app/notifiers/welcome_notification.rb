class WelcomeNotification < ApplicationNotifier
  deliver_by :database
  deliver_by :email, mailer: "UserMailer", method: "welcome_email"

  param :user

  def message
    "Welcome to our platform!"
  end

  def url
    root_url
  end
end
