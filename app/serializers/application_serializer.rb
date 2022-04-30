class ApplicationSerializer
  class Show < ActiveModel::Serializer
    attributes :name, :token, :chats_count
  end

  class Create < ActiveModel::Serializer
    attributes :name
  end
end
