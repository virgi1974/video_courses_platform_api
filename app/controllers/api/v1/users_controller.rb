module Api
  module V1
    class UsersController < ApplicationController
      # PUT /users/1/like
      def like
        user = User.find(user_params[:id])
        voter = User.find(user_params[:voter_id])

        if user && voter && user.liked_by(voter)
          head :ok
        end
      
      rescue ActiveRecord::RecordNotFound => e
        render json: { error_message: e.message }, status: :unprocessable_entity
      end

      private
        def user_params
          params.permit(:id, :voter_id, user: {})
        end
    end
  end
end
