json.extract! habit, :id, :name, :description, :start_date, :duration, :reminder, :icon, :created_at, :updated_at
json.url habit_url(habit, format: :json)
