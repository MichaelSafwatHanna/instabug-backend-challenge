# frozen_string_literal: true

class ChatSerializer
  class Show < ActiveModel::Serializer
    attributes :number, :messages_count
  end

  class Create < ActiveModel::Serializer
    attributes :number
  end
end
