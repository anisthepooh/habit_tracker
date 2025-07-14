class HabitsController < ApplicationController
  before_action :set_habit, only: %i[ show edit update destroy archive ]
  before_action :set_user
  before_action :update_status, only: [ :index, :show, :completed_index ]


  # GET /habits or /habits.json
  def index
    @habits = @user.habits.where.not(status: [ "succeeded" ]).where.not(archived: true)
    @grouped_entries = @user.entries.group_by(&:date)
  end

  def completed_index
    set_path user_path(@user), "Back to profile"
    @habits = @user.habits.where(status: "succeeded")
  end

  def archived_index
    set_path user_path(@user), "Back to profile"
    @habits = @user.habits.where(archived: "true")
  end

  # GET /habits/1 or /habits/1.json
  def show
    set_path habits_path, "Back to habits"
    @habit = Habit.find(params[:id])
    @most_mood = @habit.entries.group(:mood).order("count_id DESC").count(:id).first
    @current_streak = @habit.calculate_streak
    @completed_days = @habit.completed_days_this_week
  end

  # GET /habits/new
  def new
    set_path habits_path, "Back to habits"
    @icon_svgs = icons
    @habit = Habit.new
  end

  # GET /habits/1/edit
  def edit
    set_path habit_path(@habit), "Back to habits"
    @icon_svgs = icons
  end

  # POST /habits or /habits.json
  def create
    @habit = @user.habits.new(habit_params)

    respond_to do |format|
      if @habit.save
        flash_with_icon(:notice, "Habit was successfully created!", "check-circle")
        format.html { redirect_to @habit }
        format.json { render :show, status: :created, location: @habit }
      else
        flash_with_icon(:alert, "There was an error creating your habit.", "alert-circle")
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @habit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /habits/1 or /habits/1.json
  def update
    respond_to do |format|
      if @habit.update(habit_params)
        format.html { redirect_to @habit, notice: "Habit was successfully updated." }
        format.json { render :show, status: :ok, location: @habit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @habit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /habits/1 or /habits/1.json
  def destroy
    @habit.destroy!

    respond_to do |format|
      format.html { redirect_to habits_path, status: :see_other, notice: "Habit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def archive
    if @habit.update(archived: true)
      respond_to do |format|
        format.html { redirect_to habits_path, notice: "Habit was successfully archived." } # This is for regular HTML requests
        format.js   # Respond with JS for remote requests
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to habits_path, alert: "Something went wrong." } # For regular HTML requests on failure
        format.js   # Handle failure in JS as well
      end
    end
  end

  private

  def icons
    icon_categories = {
      "General" => %w[sun moon eye ear gift handshake fingerprint ticket wallet wallpaper paw-print trending-up camera mic send phone wand-sparkles pencil palette],
      "Sport" => %w[award circle-gauge dumbbell gauge land-plot medal trophy],
      "Nature" => %w[flame-kindling flower leaf mountain shovel sprout tree-pine tent],
      "Emoji" => %w[laugh meh annoyed frown angry hand-metal biceps-flexed heart party-popper ribbon star thumbs-up],
      "Food" => %w[apple bean beef beer beer-off candy candy-off dna-off egg-off wheat-off ice-cream-cone utensils]
    }

    # Generate SVG strings for preview (maintains compatibility)
    icon_categories.values.flatten.each_with_object({}) do |icon_name, svgs|
      svgs[icon_name] = helpers.lucide_icon(icon_name, class: "w-8 h-8")
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_habit
      @habit = Habit.find(params.expect(:id))
    end

    def set_user
      @user = Current.user
    end

    def update_status
      Current.user.habits.each do |habit|
        habit.update_status
      end
    end

    def habit_params
      params.expect(habit: [
        :name, :description, :start_date, :duration, :reminder, :icon, :archived, :status,
        :reminder_enabled, :reminder_time, reminder_channels: []
      ])
    end
end
