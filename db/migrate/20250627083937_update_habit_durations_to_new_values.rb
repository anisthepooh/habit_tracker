class UpdateHabitDurationsToNewValues < ActiveRecord::Migration[8.0]
  def up
    # Map existing durations to new values
    # 30 days -> 30 days (Medium)
    # 84 days (12 weeks) -> 90 days (Long)
    # 180 days (6 months) -> 90 days (Long)
    # 365 days (1 year) -> 90 days (Long)
    
    execute <<-SQL
      UPDATE habits 
      SET duration = CASE 
        WHEN duration = 84 THEN 90
        WHEN duration = 180 THEN 90
        WHEN duration = 365 THEN 90
        ELSE duration
      END
      WHERE duration IN (84, 180, 365)
    SQL
  end

  def down
    # Reverse mapping (this won't be perfect since we're losing data)
    execute <<-SQL
      UPDATE habits 
      SET duration = CASE 
        WHEN duration = 90 THEN 84
        ELSE duration
      END
      WHERE duration = 90
    SQL
  end
end
