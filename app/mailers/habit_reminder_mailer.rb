class HabitReminderMailer < ApplicationMailer
  def reminder_email
    @user = params[:user]
    @habit = params[:habit]
    @habit_name = @habit.name
    @streak = @habit.calculate_streak
    @entries_count = @habit.entries.count
    
    mail(
      to: @user.email_address,
      subject: "⏰ Don't forget: #{@habit_name}"
    )
  end
end