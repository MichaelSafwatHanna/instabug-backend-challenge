class ChatController < BaseApplicationController
    def index
        app = Application.includes(:chats).find_by(token: params[:application_id])
        serialized = ActiveModelSerializers::SerializableResource.new(app, each_serializer: ApplicationSerializer::Show)
        render :json => { data: serialized }, status: :ok
    end

    def show
        begin
            chat = Application.includes(:chats).find_by!(token: params[:application_id]).chats.find_by!(number: params[:id])
            serialized = ChatSerializer::Show.new(chat).as_json
            render :json => { data: serialized }, status: :ok
          rescue ActiveRecord::RecordNotFound => e
            render status: :not_found
        end
    end

    def create
        begin
            app = Application.find_by!(token: params[:application_id])
            chat = Chat.new(application_id: app.id)

            if chat.save
                render json: ChatSerializer::Create.new(chat).to_json, status: :ok
            else
                render json: { message: "Something went wrong!", errors: chat.errors }, status: :not_acceptable
            end
        rescue ActiveRecord::RecordNotFound => e
            render status: :not_found
        end
    end
end