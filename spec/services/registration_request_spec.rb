require "rails_helper"

RSpec.describe RegistrationRequest, 'call' do
  let(:user) { create(:user)}
  let(:course) { create(:course)}

  let(:valid_attributes) {
    { "title": course.title, "user_id": user.id }.with_indifferent_access
  }

  let(:invalid_attributes) {
    { "title": course.title, "user_id": 10000 }.with_indifferent_access
  }

  it "has expected structure" do
    service_response = RegistrationRequest.new(valid_attributes).call
    expect(service_response.class).to be RegistrationStruct
    expect(service_response.size).to eq 2
    expect(service_response.members.include?(:registration)).to be true
    expect(service_response.members.include?(:error_message)).to be true
  end

  context "success case" do
    it "has expected content" do
      service_response = RegistrationRequest.new(invalid_attributes).call
      expect(service_response.registration).to be nil
      expect(service_response.error_message).to_not be nil
    end
  end

  context "success case" do
    it "has expected content" do
      service_response = RegistrationRequest.new(valid_attributes).call
      expect(service_response.registration.class).to be Registration
      expect(service_response.registration.user_id).to eq user.id
      expect(service_response.registration.course_id).to eq course.id
      expect(service_response.error_message).to be nil
    end
  end
end