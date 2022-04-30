class ChatSerializer
    class Show < ActiveModel::Serializer
      attributes :number, :messages_count
      belongs_to :application

      class ApplicationSerializer < ActiveModel::Serializer
        attributes :name, :token
      end
    end

    class Create < ActiveModel::Serializer
      attributes :number
    end
end
