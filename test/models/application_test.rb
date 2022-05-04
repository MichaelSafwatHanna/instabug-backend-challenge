require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  test "should not save app without name" do
    app = Application.new

    assert_not app.save, "Saved the app without a name"
  end

  test "should generate uuid" do
    app = Application.new

    assert_not_nil app.token
  end

  test "should set chats_number to 0 by default" do
    app = Application.new

    assert_equal 0, app.chats_count
  end
end
