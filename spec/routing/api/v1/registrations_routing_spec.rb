require "rails_helper"

RSpec.describe Api::V1::RegistrationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/registrations").to route_to("api/v1/registrations#index")
    end
  end
end
