module Api
  module V1
    class MessageController < BaseApplicationController
      def index
        message = Message.joins(chat: [:application]).select('messages.*', 'applications.*')
                         .where(chats: { number: params[:chat_id], applications: { token: params[:application_id] } })
        serialized = ActiveModelSerializers::SerializableResource.new(message, each_serializer: MessageSerializer::Show)
        render json: { data: serialized }, status: :ok
      end

      def show
        message = Message.joins(chat: [:application]).select('messages.*', 'applications.*')
                         .find_by!(number: params[:id], chats: { number: params[:chat_id],
                                                                 applications: { token: params[:application_id] } })
        serialized = MessageSerializer::Show.new(message).as_json
        render json: { data: serialized }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render status: :not_found
      end

      def create
        app = Application.find_by!(token: params[:application_id])
        chat = app.chats.find_by!(number: params[:chat_id])

        message = Message.new(chat_id: chat.id)

        # reserve the number to this instance
        message.assign_number

        create_message_command = { chat_id: chat.id, number: message.number, content: message_body[:content] }
        RabbitmqConnection.instance.channel.with do |channel|
          queue = channel.queue('instabug.messages', durable: false)
          channel.default_exchange.publish(create_message_command.to_json, routing_key: queue.name)
        end

        render json: MessageSerializer::Create.new(message).to_json, status: :ok
      end

      private

      def message_body
        params.require(:message).permit(:content)
      end
    end
  end
end
