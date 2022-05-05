# frozen_string_literal: true

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "can't save message without content" do
    app = Application.new(name: 'test app')
    app.save
    chat = Chat.new(application_id: app.id, number: 1)
    chat.save

    msg = Message.new(chat_id: chat.id, number: 1)
    msg.save

    assert_not msg.save
  end

  test "can't have two messages with the same number on same chat" do
    app = Application.new(name: 'test app')
    app.save
    chat = Chat.new(application_id: app.id, number: 1)
    chat.save

    msg1 = Message.new(chat_id: chat.id, number: 1, content: 'Test')
    msg1.save

    msg2 = Message.new(chat_id: chat.id, number: 1, content: 'Test')
    assert_not msg2.save
  end

  test 'should create message' do
    app = Application.new(name: 'test app')
    app.save
    chat = Chat.new(application_id: app.id, number: 1)
    chat.save

    msg = Message.new(chat_id: chat.id, number: 1, content: 'Test')
    assert msg.save
  end
end
