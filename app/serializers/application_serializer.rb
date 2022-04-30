class ApplicationSerializer
  class Show < ActiveModel::Serializer
    attributes :name, :token, :chats_count
    has_many :chats, serializer: ChatSerializer::Show
  end

  class Create < ActiveModel::Serializer
    attributes :name
  end
end
