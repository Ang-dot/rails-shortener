require "test_helper"

class TargetUrlTest < ActiveSupport::TestCase
  
  test "valid URL" do
    target_url = TargetUrl.new
    target_url.target_url = "http://www.google.com"
    assert target_url.valid?
  end

  test "invalid URL" do
    target_url = TargetUrl.new
    target_url.target_url = "google.com"
    assert_not target_url.valid?
  end

end
