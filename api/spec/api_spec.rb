require "rack/test"
require "json"
require_relative "../app"  # Ajusta según la estructura de tu proyecto

RSpec.describe 'Application' do
  include Rack::Test::Methods

  def app
    Routes
  end

  describe "POST /login" do
    let(:user) { User.create(email: "test@example.com", password: "password123") }

    context "with valid credentials" do
      it "returns a success response with a token" do
        post "/login", { email: user.email, password: "password123" }.to_json, { "CONTENT_TYPE" => "application/json" }

        expect(last_response.status).to eq(200)

        response_body = JSON.parse(last_response.body)
        expect(response_body["success"]).to be true
        expect(response_body).to have_key("token")
      end
    end

    context "with invalid credentials" do
      it "returns an error response" do
        post "/login", { email:"testw@example.com", password: "wrong_password" }.to_json, { "CONTENT_TYPE" => "application/json" }

        expect(last_response.status).to eq(401)

        response_body = JSON.parse(last_response.body)
        expect(response_body["success"]).to be false
        expect(response_body["error"]).to eq("Invalid credentials")
      end
    end
  end
end
