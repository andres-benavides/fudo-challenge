ENV["RACK_ENV"] = "test"
require "rack/test"
require "json"
require 'rspec'
require_relative "../app"
require_relative "../app/middlewares/auth_middleware"


RSpec.describe 'Test unit' do
  include Rack::Test::Methods

  # def app
  #   @app ||= Routes.new
  #   use AuthMiddleware 
  # end
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

  describe "Product Creation", type: :request do
    let(:product_params) { { name: "Test Product" } }
    let(:headers) { { "CONTENT_TYPE" => "application/json" } }
    let!(:user) { Fabricate(:user) }
    let(:headers) { { "CONTENT_TYPE" => "application/json" } }

    let(:token) do
      post "/login", { email: user.email, password: "password123" }.to_json, headers
      response_body = JSON.parse(last_response.body)
      response_body["token"]
    end
  
  
    it "creates a product successfully with authentication" do
      post "/products", product_params.to_json, {
        "CONTENT_TYPE" => "application/json",
        "HTTP_AUTHORIZATION" => "Bearer #{token}"
      }
  
      expect(last_response.status).to eq(202)
      response_body = JSON.parse(last_response.body)
      expect(response_body["message"]).to eq("Product creation in process")
    end
  
    it "returns 401 when trying to create a product without authentication" do
      post "/products", product_params.to_json, headers
  
      expect(last_response.status).to eq(401)
      response_body = JSON.parse(last_response.body)
      expect(response_body["error"]).to eq("Unauthorized")
    end
  end

  describe "Product Listing", type: :request do
    let!(:user) { Fabricate(:user) }
    let(:headers) { { "CONTENT_TYPE" => "application/json" } }

    let(:token) do
      post "/login", { email: user.email, password: "password123" }.to_json, headers
      response_body = JSON.parse(last_response.body)
      response_body["token"]
    end
    let!(:product) { Fabricate(:product) }

  
    it "lists all products with authentication" do
      get "/products",{}, {
        "CONTENT_TYPE" => "application/json",
        "HTTP_AUTHORIZATION" => "Bearer #{token}"
      }
  
      expect(last_response.status).to eq(200)
      response_body = JSON.parse(last_response.body)
      expect(response_body["products"]).to be_an(Array)
      expect(response_body["products"].first["name"]).to eq("Test Product")
    end
  
    it "returns 401 when trying to list products without authentication" do
      get "/products", {}, headers
  
      expect(last_response.status).to eq(401)
      response_body = JSON.parse(last_response.body)
      expect(response_body["error"]).to eq("Unauthorized")
    end
  end
end