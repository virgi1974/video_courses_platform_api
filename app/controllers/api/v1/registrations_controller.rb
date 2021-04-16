module Api
  module V1
    class RegistrationsController < ApplicationController
      
      # GET /registrations
      def index
        @registrations = Registration.includes(:user, :course).all
      # @registrations.last.association(:user).loaded?
      end
    end
  end
end

