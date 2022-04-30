class MessageController < BaseApplicationController
    def index
        message = Message.joins(chat: [:application]).select("messages.*", "applications.*")
            .where(chats: { number: params[:chat_id], applications: { token: params[:application_id] } })
        serialized = ActiveModelSerializers::SerializableResource.new(message, each_serializer: MessageSerializer::Show)
        render :json => { data: serialized }, status: :ok
    end

    def show
        begin
            message = Message.joins(chat: [:application]).select("messages.*", "applications.*")
            .find_by!(number: params[:id], chats: { number: params[:chat_id], applications: { token: params[:application_id] } })
            serialized = MessageSerializer::Show.new(message).as_json
            render :json => { data: serialized }, status: :ok
          rescue ActiveRecord::RecordNotFound => e
            render status: :not_found
        end
    end

    def create
        begin
            app = Application.find_by!(token: params[:application_id])
            chat = app.chats.find_by!(number: params[:chat_id])
            message = Message.new(chat_id: chat.id, content: message_body[:content])

            if message.save
                render json: MessageSerializer::Create.new(chat).to_json, status: :ok
            else
                render json: { message: "Something went wrong!", errors: chat.errors }, status: :not_acceptable
            end
        rescue ActiveRecord::RecordNotFound => e
            render status: :not_found
        end
    end

    private def message_body
        params.require(:message).permit(:content)
    end
end