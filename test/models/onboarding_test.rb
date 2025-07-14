require "test_helper"

class OnboardingTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @onboarding = Onboarding.new(user: @user, guide_name: "test_guide")
  end

  test "should be valid with user and guide_name" do
    assert @onboarding.valid?
  end

  test "should require guide_name" do
    @onboarding.guide_name = nil
    assert_not @onboarding.valid?
    assert_includes @onboarding.errors[:guide_name], "can't be blank"
  end

  test "should require user" do
    @onboarding.user = nil
    assert_not @onboarding.valid?
    assert_includes @onboarding.errors[:user], "must exist"
  end

  test "should enforce uniqueness of guide_name per user" do
    @onboarding.save!
    duplicate = Onboarding.new(user: @user, guide_name: "test_guide")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:guide_name], "has already been taken"
  end

  test "should allow same guide_name for different users" do
    @onboarding.save!
    other_user = users(:two)
    other_onboarding = Onboarding.new(user: other_user, guide_name: "test_guide")
    assert other_onboarding.valid?
  end

  test "viewed? returns false when viewed_at is nil" do
    assert_not @onboarding.viewed?
  end

  test "viewed? returns true when viewed_at is present" do
    @onboarding.viewed_at = Time.current
    assert @onboarding.viewed?
  end

  test "completed? returns false when completed_at is nil" do
    assert_not @onboarding.completed?
  end

  test "completed? returns true when completed_at is present" do
    @onboarding.completed_at = Time.current
    assert @onboarding.completed?
  end

  test "mark_viewed! sets viewed_at if not already viewed" do
    @onboarding.save!
    assert_nil @onboarding.viewed_at
    
    @onboarding.mark_viewed!
    assert_not_nil @onboarding.reload.viewed_at
  end

  test "mark_viewed! does not update viewed_at if already viewed" do
    @onboarding.viewed_at = 1.hour.ago
    @onboarding.save!
    original_time = @onboarding.viewed_at
    
    @onboarding.mark_viewed!
    assert_equal original_time, @onboarding.reload.viewed_at
  end

  test "mark_completed! sets completed_at if not already completed" do
    @onboarding.save!
    assert_nil @onboarding.completed_at
    
    @onboarding.mark_completed!
    assert_not_nil @onboarding.reload.completed_at
  end

  test "mark_completed! does not update completed_at if already completed" do
    @onboarding.completed_at = 1.hour.ago
    @onboarding.save!
    original_time = @onboarding.completed_at
    
    @onboarding.mark_completed!
    assert_equal original_time, @onboarding.reload.completed_at
  end

  test "scopes work correctly" do
    viewed_onboarding = Onboarding.create!(user: @user, guide_name: "viewed_guide", viewed_at: Time.current)
    completed_onboarding = Onboarding.create!(user: @user, guide_name: "completed_guide", completed_at: Time.current)
    pending_onboarding = Onboarding.create!(user: @user, guide_name: "pending_guide")

    assert_includes Onboarding.viewed, viewed_onboarding
    assert_includes Onboarding.completed, completed_onboarding
    assert_includes Onboarding.for_guide("viewed_guide"), viewed_onboarding
  end
end
