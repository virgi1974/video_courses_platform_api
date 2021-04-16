module Api
  module V1
    class RegistrationsController < ApplicationController
      
      # GET /registrations
      def index
        @registrations = Registration.includes(:user, :course).all
      end
      
      # POST /registrations
      def create
        course = Course.find_or_create_by!(title: registration_params["title"])
        user = User.find(registration_params["user_id"])

        existing_registration = Registration.find_by(user_id: user.id, course_id: course.id)
        if existing_registration
          raise Registration::AlreadyCreatedError.new("you already have applied for that course")
        end

        @registration = Registration.new(user: user, course: course)
        if @registration.save
          render status: :created
        else
          raise Registration::CreationError.new("Error creating a new registration") 
        end
      
      rescue => e
        render json: { error_message: e.message }, status: :unprocessable_entity
      end

      private
      
        # Only allow a list of trusted parameters through.
        def registration_params
          params.permit(:title, :user_id, registration: {})
        end
    end
  end
end

