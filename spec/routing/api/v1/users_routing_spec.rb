require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :routing do
  describe "routing" do
    it "routes to #like via PUT" do
      expect(put: "/api/v1/users/1/like").to route_to("api/v1/users#like", id: "1")
    end
  end
end
