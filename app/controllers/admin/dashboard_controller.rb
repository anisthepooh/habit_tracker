class Admin::DashboardController < Admin::BaseController
  before_action :set_breadcrumbs
  def index
    add_breadcrumb("Dashboard", admin_dashboard_path)
      @cards = [
      {
        title: "Users",
        count: User.count,
        data_description: user_growth_description,
        description: "Visitors for the last 6 months",
        path: admin_users_path,
        growth_in_procent: calculate_growth(User)
      },
      {
        title: "Habits",
        count: Habit.count,
        data_description: habit_growth_description,
        description: "Habits created in the last 6 months",
        path: admin_habits_path,
        growth_in_procent: calculate_growth(Habit)
      },
      {
        title: "Entries",
        count: Entry.count,
        data_description: entry_growth_description,
        description: "Entries logged in the last 6 months",
        path: admin_entries_path,
        growth_in_procent: calculate_growth(Entry)
      }
    ]

    @activities = PublicActivity::Activity.all
  end



  private

    def user_growth_description
      period_start = 6.months.ago
      new_users = User.where("created_at >= ?", period_start).count
      "#{new_users} new #{'user'.pluralize(new_users)} for the last 6 months"
    end

    def habit_growth_description
      period_start = 6.months.ago
      new_habits = Habit.where("created_at >= ?", period_start).count
      "#{new_habits} new #{'habit'.pluralize(new_habits)} for the last 6 months"
    end

    def entry_growth_description
      period_start = 6.months.ago
      new_entries = Entry.where("created_at >= ?", period_start).count
      "#{new_entries} new #{'entry'.pluralize(new_entries)} for the last 6 months"
    end

    def calculate_growth(model)
      now = Time.current
      current_period_start = 6.months.ago
      previous_period_start = 12.months.ago

      current_count = model.where(created_at: current_period_start..now).count
      previous_count = model.where(created_at: previous_period_start...current_period_start).count

      growth = if previous_count.zero?
        current_count.positive? ? 100 : 0
      else
        ((current_count - previous_count) / previous_count.to_f * 100).round
      end
      growth
    end


    def set_breadcrumbs
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email_address, :role)
    end
end
