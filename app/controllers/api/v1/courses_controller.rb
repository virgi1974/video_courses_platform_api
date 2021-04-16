module Api
  module V1
    class CoursesController < ApplicationController
      # PUT /courses/1/like
      def like
        course = Course.find(course_params[:id])
        voter = User.find(course_params[:voter_id])

        if course && voter && course.liked_by(voter)
          head :ok
        end
      
      rescue ActiveRecord::RecordNotFound => e
        render json: { error_message: e.message }, status: :unprocessable_entity
      end

      private

        def course_params
          params.permit(:id, :voter_id, course: {})
        end
    end
  end
end


