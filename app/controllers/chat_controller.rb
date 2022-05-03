class ChatController < BaseApplicationController
    def index
        chats = Chat.includes(:application).where(applications: { token: params[:application_id] })
        serialized = ActiveModelSerializers::SerializableResource.new(chats, each_serializer: ChatSerializer::Show)
        render :json => { data: serialized }, status: :ok
    end

    def show
        begin
            chat = Chat.includes(:application).find_by!(number: params[:id], applications: { token: params[:application_id] })
            serialized = ChatSerializer::Show.new(chat).as_json
            render :json => { data: serialized }, status: :ok
          rescue ActiveRecord::RecordNotFound => e
            render status: :not_found
        end
    end

    def create
        app = Application.find_by!(token: params[:application_id])
        create_chat_command = { app_id: app.id }

        RabbitmqConnection.instance.channel.with do |channel|
            queue = channel.queue('instabug.chats', durable: false)
            channel.default_exchange.publish(create_chat_command.to_json, routing_key: queue.name)
        end

        chat = Chat.new(application_id: app.id)
        render json: ChatSerializer::Create.new(chat).to_json, status: :ok
    end
end