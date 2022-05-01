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
        begin
            Chat.transaction do
                app = Application.find_by!(token: params[:application_id])
                chat = Chat.new(application_id: app.id)
                if chat.save
                    chat.respect_counters
                    render json: ChatSerializer::Create.new(chat).to_json, status: :ok
                else
                    raise ActiveRecord::Rollback
                    render json: { message: "Something went wrong!", errors: chat.errors }, status: :internal_server_error
                end
            end
        rescue ActiveRecord::RecordNotFound => e
            render status: :not_found
        end
    end
end