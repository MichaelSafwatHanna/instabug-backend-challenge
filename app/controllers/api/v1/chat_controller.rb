module Api
  module V1
    class ChatController < BaseApplicationController
      def index
        chats = Chat.includes(:application).where(applications: { token: params[:application_id] })
        serialized = ActiveModelSerializers::SerializableResource.new(chats, each_serializer: ChatSerializer::Show)
        render json: { data: serialized }, status: :ok
      end

      def show
        chat = Chat.includes(:application).find_by!(number: params[:id],
                                                    applications: { token: params[:application_id] })
        serialized = ChatSerializer::Show.new(chat).as_json
        render json: { data: serialized }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render status: :not_found
      end

      def create
        app = Application.find_by!(token: params[:application_id])
        chat = Chat.new(application_id: app.id)

        # reserve the number to this instance
        chat.assign_number

        create_chat_command = { app_id: app.id, number: chat.number }

        RabbitmqConnection.instance.channel.with do |channel|
          queue = channel.queue('instabug.chats', durable: false)
          channel.default_exchange.publish(create_chat_command.to_json, routing_key: queue.name)
        end

        render json: ChatSerializer::Create.new(chat).to_json, status: :ok
      end

      def search
        app_token = params[:application_id]
        chat_number = params[:chat_id]
        query = search_query
        result = Message.search_content(app_token, chat_number, query)
        render json: result.to_json, status: :ok
      end

      private

      def search_query
        params.require(:query)
      end
    end
  end
end
