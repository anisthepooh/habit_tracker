# test/mailers/previews/user_mailer_preview.rb

class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.first || User.new(name: "Casper", email: "delivered@resend.dev")
    UserMailer.with(user: user).welcome_email
  end
end
