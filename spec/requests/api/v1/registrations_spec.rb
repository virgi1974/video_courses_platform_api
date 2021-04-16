require 'rails_helper'

RSpec.describe "/api/v1/registrations", type: :request do
  let(:user) { create(:user)}
  let(:course) { create(:course)}

  let(:valid_attributes_new_course) {
    { "title": "React latest version", "user_id": user.id }
  }
  let(:valid_attributes_existing_course) {
    { "title": course.title, "user_id": user.id }
  }
  let(:invalid_title_attr) {
    { "title": "", "user_id": 10000 }
  }
  let(:invalid_user_id_attr) {
    { "title": "some cool course", "user_id": 10000 }
  }
  let(:invalid_missing_title_attr) {
    { "user_id": 1 }
  }
  let(:invalid_missing_user_id_attr) {
    { "title": "some cool course" }
  }
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
          user_keys = %w[id email likes]
          user_keys.each do |key|
            expect(user[key]).to eq(registration.user.send(key))
          end         
          
          # course data
          course = parsed_response["registrations"][0]["course"]
          course_keys = %w[id title likes]
          course_keys.each do |key|
            expect(course[key]).to eq(registration.course.send(key))
          end
        end
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      context "creating new course" do
        it "uses title from an existing course" do
          existing_course_before_post = Course.find_by(title: valid_attributes_new_course[:title])
          expect(existing_course_before_post).to be nil
          post api_v1_registrations_url, params: valid_attributes_new_course, headers: headers, as: :json
          existing_course_after_post = Course.find_by(title: valid_attributes_new_course[:title])
          expect(existing_course_after_post).to_not be nil
        end

        it "creates a new Registration" do
          expect {
            post api_v1_registrations_url, 
            params: valid_attributes_new_course, 
            headers: headers, 
            as: :json
          }.to change(Registration, :count).by(1)
        end
        
        it "renders a successful response" do
          post api_v1_registrations_url, params: valid_attributes_new_course, headers: headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "using existing course" do
        it "fails if related Registration already exists" do
          existing_user = User.find(valid_attributes_existing_course[:user_id])
          existing_course = Course.find_by(title: valid_attributes_existing_course[:title])
          created_registration = Registration.create(user: existing_user, course: existing_course)

          expect {
            post api_v1_registrations_url, 
            params: valid_attributes_existing_course, 
            headers: headers, 
            as: :json
          }.to change(Registration, :count).by(0)
          expect(parsed_response.key?("error_message")).to be true
          expect(parsed_response["error_message"]).to eq("you already have applied for that course")
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "succeeds if related Registration does not exists" do
          existing_user = User.find(valid_attributes_existing_course[:user_id])
          existing_course = Course.find_by(title: valid_attributes_existing_course[:title])
          existing_registration = Registration.find_by(user: existing_user.id, course: existing_course.id)
          expect(existing_registration).to be nil
          expect {
            post api_v1_registrations_url, 
            params: valid_attributes_existing_course, 
            headers: headers, 
            as: :json
          }.to change(Registration, :count).by(1)
        end
      end
    end

    context "with invalid parameters" do
      context "does not create a new Registration" do
        it "when empty title" do
          expect {
            post api_v1_registrations_url, 
            params: invalid_title_attr, 
            headers: headers, 
            as: :json
          }.to change(Registration, :count).by(0)
          expect(parsed_response.key?("error_message")).to be true
          expect(parsed_response["error_message"]).to eq("Validation failed: Title can't be blank")
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "when non existing user" do
          expect {
            post api_v1_registrations_url, 
            params: invalid_user_id_attr, 
            headers: headers, 
            as: :json
          }.to change(Registration, :count).by(0)
          expect(parsed_response.key?("error_message")).to be true
          expect(parsed_response["error_message"]).to eq("Couldn't find User with 'id'=10000")
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "when missing title" do
          expect {
            post api_v1_registrations_url, 
            params: invalid_missing_title_attr, 
            headers: headers, 
            as: :json
          }.to change(Registration, :count).by(0)
          expect(parsed_response.key?("error_message")).to be true
          expect(parsed_response["error_message"]).to eq("Validation failed: Title can't be blank")
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "when missing user id" do
          expect {
            post api_v1_registrations_url, 
            params: invalid_missing_user_id_attr, 
            headers: headers, 
            as: :json
          }.to change(Registration, :count).by(0)
          expect(parsed_response.key?("error_message")).to be true
          expect(parsed_response["error_message"]).to eq("Couldn't find User without an ID")
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
