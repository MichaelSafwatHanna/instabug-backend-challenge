# frozen_string_literal: true

require 'test_helper'

class ChatTest < ActiveSupport::TestCase
  test "can't have two chats with the same number on same app" do
    app = Application.new(name: 'test app')
    app.save
    chat1 = Chat.new(application_id: app.id, number: 1)
    chat2 = Chat.new(application_id: app.id, number: 1)
    chat1.save
    assert_not chat2.save
  end

  test 'should create chat' do
    app = Application.new(name: 'test app')
    app.save
    chat = Chat.new(application_id: app.id, number: 1)
    chat.save
    assert chat.save
  end
end
