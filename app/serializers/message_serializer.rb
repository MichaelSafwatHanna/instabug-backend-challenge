# frozen_string_literal: true

class MessageSerializer
  class Show < ActiveModel::Serializer
    attributes :number, :content
  end

  class Create < ActiveModel::Serializer
    attributes :number
  end
end
