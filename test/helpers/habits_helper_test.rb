require "test_helper"

class HabitsHelperTest < ActionView::TestCase
  test "duration_label returns correct labels for standard durations" do
    assert_equal "Tiny", duration_label(7)
    assert_equal "Short", duration_label(14)
    assert_equal "Medium", duration_label(30)
    assert_equal "Long", duration_label(90)
  end

  test "duration_label returns Custom for non-standard durations" do
    assert_equal "Custom", duration_label(45)
    assert_equal "Custom", duration_label(365)
  end

  test "duration_display returns formatted display for standard durations" do
    assert_equal "Tiny (7 days)", duration_display(7)
    assert_equal "Short (14 days)", duration_display(14)
    assert_equal "Medium (30 days)", duration_display(30)
    assert_equal "Long (90 days)", duration_display(90)
  end

  test "duration_display returns days only for custom durations" do
    assert_equal "45 days", duration_display(45)
    assert_equal "365 days", duration_display(365)
  end
end