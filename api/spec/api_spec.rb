require "rack/test"
require "json"
require 'rspec'
require_relative "../app"

RSpec.describe 'Test unit' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do
    header "Host", "rack_app"
  end

  it "Login without data" do
    post '/login', email: "corre@test.com", password: "password123"
  
    puts "Response Status: #{last_response.status}"
    puts "Response Body: #{last_response.body}"
  
    expect(last_response.status).to eq(401)
  end
end