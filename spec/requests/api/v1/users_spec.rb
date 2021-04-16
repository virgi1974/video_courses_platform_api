# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:user) { create(:user) }
  let(:voter) { create(:user) }

  let(:valid_attributes_other_voter) do
    { "voter_id": voter.id }
  end

  let(:valid_attributes_self_voter) do
    { "voter_id": user.id }
  end

  let(:invalid_voter_attr) do
    { "voter_id": 10_000 }
  end

  let!(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe 'PUT /like' do
    context 'with valid parameters' do
      it 'increases the number of likes' do
        expect(user.get_likes.size).to eq 0
        put "/api/v1/users/#{user.id}/like", params: valid_attributes_other_voter, headers: headers, as: :json
        expect(user.get_likes.size).to eq 1
      end

      it 'can vote only once for same user' do
        expect(user.get_likes.size).to eq 0
        3.times do
          put "/api/v1/users/#{user.id}/like", params: valid_attributes_other_voter, headers: headers, as: :json
        end
        expect(user.get_likes.size).to eq 1
        expect(user.voted_up_by?(voter)).to be true
      end

      it 'can vote to itself' do
        expect(user.get_likes.size).to eq 0
        3.times do
          put "/api/v1/users/#{user.id}/like", params: valid_attributes_self_voter, headers: headers, as: :json
        end
        expect(user.get_likes.size).to eq 1
        expect(user.voted_up_by?(user)).to be true
      end

      it 'renders a JSON response with no content' do
        put "/api/v1/users/#{user.id}/like", params: valid_attributes_other_voter, headers: headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('')
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      context 'when voter is not valid' do
        it 'does not increase the number of likes' do
          expect(user.get_likes.size).to eq 0
          put "/api/v1/users/#{user.id}/like", params: invalid_voter_attr, headers: headers, as: :json
          expect(user.get_likes.size).to eq 0
        end

        it 'renders a JSON response with errors' do
          put "/api/v1/users/#{user.id}/like", params: invalid_voter_attr, headers: headers, as: :json
          expect(parsed_response.key?('error_message')).to be true
          expect(parsed_response['error_message']).to eq("Couldn't find User with 'id'=10000")
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'when user being voted is not valid' do
        it 'renders a JSON response with errors' do
          put '/api/v1/users/9999/like', params: valid_attributes_other_voter, headers: headers, as: :json
          expect(parsed_response.key?('error_message')).to be true
          expect(parsed_response['error_message']).to eq("Couldn't find User with 'id'=9999")
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end
  end
end
