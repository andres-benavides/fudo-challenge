ENV["RACK_ENV"] = "test"
require "rack/test"
require "json"
require 'rspec'
require_relative "../../app"
require_relative "../../app/middlewares/auth_middleware"


RSpec.describe 'Test unit for users' do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use AuthMiddleware
      run Routes
    end
  end

  before do
    header "Host", "localhost"
  end

  describe "User Login", type: :request do
    let(:user_params) { { email: "testuser@example.com", password: "password123" } }
  
    before do
      post "/signup", user_params.to_json, { "CONTENT_TYPE" => "application/json" }
    end
  
    it "logs in successfully with correct credentials" do
      post "/login", user_params.to_json, { "CONTENT_TYPE" => "application/json" }
  
      expect(last_response.status).to eq(200)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key("token")
    end
  
    it "returns 401 for incorrect credentials" do
      post "/login", { email: "wrong@example.com", password: "wrongpass" }.to_json, { "CONTENT_TYPE" => "application/json" }
  
      expect(last_response.status).to eq(401)
      response_body = JSON.parse(last_response.body)
      expect(response_body["error"]).to eq("Invalid credentials")
    end
  end

  describe "User Signup", type: :request do
    it "creates a new user successfully" do
      post "/signup", { email: "testuser@example.com", password: "password123" }.to_json, { "CONTENT_TYPE" => "application/json" }
  
      expect(last_response.status).to eq(201)
      response_body = JSON.parse(last_response.body)
      expect(response_body["message"]).to eq("User created")
    end
  end

  describe "User Signup with invalid email", type: :request do
    it "creates a new user successfully" do
      post "/signup", { email: "myuser", password: "password123" }.to_json, { "CONTENT_TYPE" => "application/json" }
  
      expect(last_response.status).to eq(422)
      response_body = JSON.parse(last_response.body)
      expect(response_body["error"]["email"].first).to eq("is in invalid format")
    end
  end
end