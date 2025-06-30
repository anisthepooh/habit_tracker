require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "ios_device? returns true for iPhone user agent" do
    request.user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15"
    assert ios_device?
  end

  test "ios_device? returns true for iPad user agent" do
    request.user_agent = "Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15"
    assert ios_device?
  end

  test "ios_device? returns true for iPod user agent" do
    request.user_agent = "Mozilla/5.0 (iPod touch; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15"
    assert ios_device?
  end

  test "ios_device? returns false for Android user agent" do
    request.user_agent = "Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36"
    assert_not ios_device?
  end

  test "ios_device? returns false for desktop Chrome user agent" do
    request.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    assert_not ios_device?
  end

  test "ios_device? returns false when user agent is nil" do
    request.user_agent = nil
    assert_not ios_device?
  end

  test "ios_device? is case insensitive" do
    request.user_agent = "Mozilla/5.0 (IPHONE; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15"
    assert ios_device?
  end
end
