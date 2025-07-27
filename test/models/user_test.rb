require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "password validation requires minimum 8 characters" do
    user = User.new(email_address: "test@example.com", password: "Short1")
    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"
  end

  test "password validation requires uppercase letter and digit" do
    user = User.new(email_address: "test@example.com", password: "lowercase")
    assert_not user.valid?
    assert_includes user.errors[:password], "must contain at least one uppercase letter and one digit"
  end

  test "valid password passes validation" do
    user = User.new(email_address: "test@example.com", password: "ValidPass123")
    user.valid?
    assert_not_includes user.errors[:password], "is too short (minimum is 8 characters)"
    assert_not_includes user.errors[:password], "must contain at least one uppercase letter and one digit"
  end
end
