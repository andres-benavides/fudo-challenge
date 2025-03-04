ENV["RACK_ENV"] = "test"
require "rack/test"
require "json"
require 'rspec'
require_relative "../../app"
require_relative "../../app/middlewares/auth_middleware"


RSpec.describe 'Test unit for products' do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use AuthMiddleware
      run Routes
    end
  end

  before do
    header "Host", "localhost"
    allow(CreateProductJob).to receive(:perform_async)
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
      expect(CreateProductJob).to have_received(:perform_async).with("Test Product")
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