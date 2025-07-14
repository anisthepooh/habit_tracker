require "test_helper"

class UserOnboardingTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "has_seen_onboarding? returns false when no onboarding record exists" do
    assert_not @user.has_seen_onboarding?("nonexistent_guide")
  end

  test "has_seen_onboarding? returns false when onboarding exists but not viewed" do
    @user.onboardings.create!(guide_name: "test_guide_not_viewed")
    assert_not @user.has_seen_onboarding?("test_guide_not_viewed")
  end

  test "has_seen_onboarding? returns true when onboarding is viewed" do
    @user.onboardings.create!(guide_name: "test_guide_viewed", viewed_at: Time.current)
    assert @user.has_seen_onboarding?("test_guide_viewed")
  end

  test "has_completed_onboarding? returns false when no onboarding record exists" do
    assert_not @user.has_completed_onboarding?("nonexistent_guide")
  end

  test "has_completed_onboarding? returns false when onboarding exists but not completed" do
    @user.onboardings.create!(guide_name: "test_guide_incomplete", viewed_at: Time.current)
    assert_not @user.has_completed_onboarding?("test_guide_incomplete")
  end

  test "has_completed_onboarding? returns true when onboarding is completed" do
    @user.onboardings.create!(guide_name: "test_guide_complete", completed_at: Time.current)
    assert @user.has_completed_onboarding?("test_guide_complete")
  end

  test "mark_onboarding_viewed creates new onboarding and marks as viewed" do
    assert_difference "@user.onboardings.count", 1 do
      onboarding = @user.mark_onboarding_viewed("new_test_guide")
      assert onboarding.viewed?
      assert_not onboarding.completed?
    end
  end

  test "mark_onboarding_viewed marks existing onboarding as viewed" do
    existing = @user.onboardings.create!(guide_name: "existing_test_guide")
    assert_not existing.viewed?

    assert_no_difference "@user.onboardings.count" do
      onboarding = @user.mark_onboarding_viewed("existing_test_guide")
      assert onboarding.viewed?
      assert_equal existing.id, onboarding.id
    end
  end

  test "mark_onboarding_viewed does not update already viewed onboarding" do
    existing = @user.onboardings.create!(guide_name: "already_viewed_guide", viewed_at: 1.hour.ago)
    original_time = existing.viewed_at

    onboarding = @user.mark_onboarding_viewed("already_viewed_guide")
    assert_equal original_time, onboarding.reload.viewed_at
  end

  test "mark_onboarding_completed creates new onboarding and marks as viewed and completed" do
    assert_difference "@user.onboardings.count", 1 do
      onboarding = @user.mark_onboarding_completed("new_complete_guide")
      assert onboarding.viewed?
      assert onboarding.completed?
    end
  end

  test "mark_onboarding_completed marks existing onboarding as viewed and completed" do
    existing = @user.onboardings.create!(guide_name: "existing_complete_guide")
    assert_not existing.viewed?
    assert_not existing.completed?

    assert_no_difference "@user.onboardings.count" do
      onboarding = @user.mark_onboarding_completed("existing_complete_guide")
      assert onboarding.viewed?
      assert onboarding.completed?
      assert_equal existing.id, onboarding.id
    end
  end

  test "mark_onboarding_completed does not update already completed onboarding" do
    existing = @user.onboardings.create!(
      guide_name: "already_complete_guide", 
      viewed_at: 2.hours.ago, 
      completed_at: 1.hour.ago
    )
    original_viewed_time = existing.viewed_at
    original_completed_time = existing.completed_at

    onboarding = @user.mark_onboarding_completed("already_complete_guide")
    onboarding.reload
    assert_equal original_viewed_time, onboarding.viewed_at
    assert_equal original_completed_time, onboarding.completed_at
  end

  test "onboarding_for returns the onboarding record for the guide" do
    onboarding = @user.onboardings.create!(guide_name: "test_for_guide")
    assert_equal onboarding, @user.onboarding_for("test_for_guide")
  end

  test "onboarding_for returns nil when no onboarding exists" do
    assert_nil @user.onboarding_for("nonexistent_guide")
  end
end