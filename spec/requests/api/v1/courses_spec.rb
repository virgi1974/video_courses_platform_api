require 'rails_helper'

RSpec.describe "/courses", type: :request do
  let(:course) { create(:course)}
  let(:voter) { create(:user)}

  let(:valid_attributes) {
    { "voter_id": voter.id }
  }

  let(:invalid_voter_attr) {
    { "voter_id": 10000 }
  }

  let!(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe "PUT /like" do
    context "with valid parameters" do

      it "increases the number of likes" do
        expect(course.get_likes.size).to eq 0
        put "/api/v1/courses/#{course.id}/like", params: valid_attributes, headers: headers, as: :json
        expect(course.get_likes.size).to eq 1
      end
      
      it "can vote only once for same course" do
        expect(course.get_likes.size).to eq 0
        3.times do
          put "/api/v1/courses/#{course.id}/like", params: valid_attributes, headers: headers, as: :json
        end
        expect(course.get_likes.size).to eq 1
        expect(course.voted_up_by?(voter)).to be true
      end
      
      it "renders a JSON response with no content" do
        put "/api/v1/courses/#{course.id}/like", params: valid_attributes, headers: headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq("")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      context "when voter is not valid" do
        it "does not increase the number of likes" do
          expect(course.get_likes.size).to eq 0
          put "/api/v1/courses/#{course.id}/like", params: invalid_voter_attr, headers: headers, as: :json
          expect(course.get_likes.size).to eq 0
        end
  
        it "renders a JSON response with errors" do
          put "/api/v1/courses/#{course.id}/like", params: invalid_voter_attr, headers: headers, as: :json
          expect(parsed_response.key?("error_message")).to be true
          expect(parsed_response["error_message"]).to eq("Couldn't find User with 'id'=10000")
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context "when course being voted is not valid" do  
        it "renders a JSON response with errors" do
          put "/api/v1/courses/9999/like", params: valid_attributes, headers: headers, as: :json
          expect(parsed_response.key?("error_message")).to be true
          expect(parsed_response["error_message"]).to eq("Couldn't find Course with 'id'=9999")
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end
  end
end
