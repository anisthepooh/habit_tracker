require "application_system_test_case"

class HabitsTest < ApplicationSystemTestCase
  setup do
    @habit = habits(:one)
  end

  test "visiting the index" do
    visit habits_url
    assert_selector "h1", text: "Habits"
  end

  test "should create habit" do
    visit habits_url
    click_on "New habit"

    fill_in "Description", with: @habit.description
    fill_in "Duration", with: @habit.duration
    fill_in "Icon", with: @habit.icon
    fill_in "Name", with: @habit.name
    check "Reminder" if @habit.reminder
    fill_in "Start date", with: @habit.start_date
    click_on "Create Habit"

    assert_text "Habit was successfully created"
    click_on "Back"
  end

  test "should update Habit" do
    visit habit_url(@habit)
    click_on "Edit this habit", match: :first

    fill_in "Description", with: @habit.description
    fill_in "Duration", with: @habit.duration
    fill_in "Icon", with: @habit.icon
    fill_in "Name", with: @habit.name
    check "Reminder" if @habit.reminder
    fill_in "Start date", with: @habit.start_date
    click_on "Update Habit"

    assert_text "Habit was successfully updated"
    click_on "Back"
  end

  test "should destroy Habit" do
    visit habit_url(@habit)
    accept_confirm { click_on "Destroy this habit", match: :first }

    assert_text "Habit was successfully destroyed"
  end
end
