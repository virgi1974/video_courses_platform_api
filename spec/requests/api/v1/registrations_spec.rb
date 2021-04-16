require 'rails_helper'

RSpec.describe "/api/v1/registrations", type: :request do
  let!(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe "GET /index" do
    it "renders a successful response" do
      get api_v1_registrations_url, headers: headers, as: :json
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
    
    context 'has expected structure' do
      describe 'when not created registrations' do
        before do
          get api_v1_registrations_url, headers: headers, as: :json
        end

        it 'has expected structure' do
          expect(parsed_response).not_to be_empty
          expect(parsed_response).to eq({"registrations"=>[]})
          expect(parsed_response.keys.size).to eq(1)
  
          expected_response_keys = %w[registrations]
          expected_response_keys.each do |key|
            expect(parsed_response.keys).to include(key)
          end
        end
      end

      describe 'when having created registrations' do
        let!(:registration) {create(:registration)}

        before do
          get api_v1_registrations_url, headers: headers
        end

        it 'has expected associations included' do
          expected_included_associations = [:user, :course]
          expected_included_associations.each do |association|
            registration.association(association).loaded?
          end
        end
        
        it 'has expected structure' do
          expect(parsed_response).not_to be_empty

          # registration structure
          registrations = parsed_response["registrations"]
          expect(registrations).not_to be_empty
          expect(registrations.size).to eq(1)
          expect(registrations[0].keys.size).to eq(3)
          expected_registration_keys = %w[user course created_at]
          expected_registration_keys.each do |key|
            expect(registrations[0].keys).to include(key)
          end

          # user structure
          user = parsed_response["registrations"][0]["user"]
          expect(user).not_to be_empty
          expect(user.keys.size).to eq(3)
          expected_user_keys = %w[id email likes]
          expected_user_keys.each do |key|
            expect(user).to include(key)
          end         
          
          # course structure
          course = parsed_response["registrations"][0]["course"]
          expect(course).not_to be_empty
          expect(course.keys.size).to eq(3)
          expected_course_keys = %w[id title likes]
          expected_course_keys.each do |key|
            expect(course).to include(key)
          end
        end

        it 'has expected values' do
          # registration data
          registrations = parsed_response["registrations"]
          expect(registrations[0]["created_at"]).to eq(registration.send(:created_at).strftime('%m/%d/%Y - %I:%M%p'))
          
          # user data
          user = parsed_response["registrations"][0]["user"]
          user_keys = %w[id email]
          user_keys.each do |key|
            expect(user[key]).to eq(registration.user.send(key))
          end         
          
          # course data
          course = parsed_response["registrations"][0]["course"]
          course_keys = %w[id title]
          course_keys.each do |key|
            expect(course[key]).to eq(registration.course.send(key))
          end
        end
      end
    end
  end
end
