# frozen_string_literal: true

class ApplicationSerializer
  class Show < ActiveModel::Serializer
    attributes :name, :token, :chats_count
  end

  class Create < ActiveModel::Serializer
    attributes :token
  end
end
