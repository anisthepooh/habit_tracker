class EntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update destroy ]

  # GET /entries or /entries.json
  def index
    @entries = Entry.all
    @habit = Habit.find(params[:habit_id])
  end

  # GET /entries/1 or /entries/1.json
  def show
    @habit = Habit.find(params[:habit_id])
  end

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries or /entries.json
  def create
    @habit = Habit.find(params[:habit_id])
    @entry = @habit.entries.new(entry_params)

    respond_to do |format|
      if @entry.save
        format.turbo_stream
        format.html do
          redirect_to habit_entry_path(@habit, @entry), notice: "Entry was successfully created."
        end
        format.json do
          render :show, status: :created, location: habit_entry_path(@habit, @entry)
        end
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:modal, partial: "entries/form", locals: { entry: @entry }) }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /entries/1 or /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to @entry, notice: "Entry was successfully updated." }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1 or /entries/1.json
  def destroy
    @entry.destroy!

    respond_to do |format|
      format.html { redirect_to habit_entries_path, status: :see_other, notice: "Entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def entry_params
      params.expect(entry: [ :date, :description, :mood ])
    end
end
