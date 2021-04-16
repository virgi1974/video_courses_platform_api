# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < ApplicationController
      # GET /registrations
      def index
        @total_registrations = Registration.count
        @registrations = Registration.includes(:user, :course).paginate(page: params[:page], per_page: 5)
      end

      # POST /registrations
      def create
        service_response = RegistrationRequest.new(registration_params).call
        @registration = service_response.registration || service_response

        if service_response.registration
          render status: :created
        else
          render json: { error_message: @registration.error_message }, status: :unprocessable_entity
        end
      end

      private

      # Only allow a list of trusted parameters through.
      def registration_params
        params.permit(:title, :user_id, registration: {})
      end
    end
  end
end
