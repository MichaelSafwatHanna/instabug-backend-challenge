# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < BaseApplicationController
      def index
        apps = Application.all
        serialized = ActiveModelSerializers::SerializableResource.new(apps,
                                                                      each_serializer: ApplicationSerializer::Show)
        render json: { data: serialized }, status: :ok
      end

      def show
        app = Application.find_by!(token: params[:id])
        render json: { data: ApplicationSerializer::Show.new(app).as_json }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render status: :not_found
      end

      def create
        app = Application.new(app_body)

        if app.save
          render json: ApplicationSerializer::Create.new(app).to_json, status: :ok
        else
          render json: { message: 'Something went wrong!', errors: app.errors }, status: :not_acceptable
        end
      end

      def update
        app = Application.find_by!(token: params[:id])
        app.name = app_body[:name]

        if app.save
          render json: ApplicationSerializer::Create.new(app).to_json, status: :ok
        else
          render json: { message: 'Something went wrong!', errors: app.errors }, status: :not_acceptable
        end
      end

      private

      def app_body
        params.require(:application).permit(:name)
      end
    end
  end
end
