require 'sinatra/base'
require_relative '../app/controllers/users_controller'
require_relative '../app/controllers/products_controller'

class Routes < Sinatra::Base
  # set :bind, '0.0.0.0'
  # set :port, 9292   
  # set :allow_origin, '*'
  # set :protection, :except => :http_origin
  before do
    puts "Request Path: #{request.path}"
    puts "Headers: #{request.env.inspect}"
    content_type :json
  end

  post '/signup' do
    UsersController.register(request)
  end

  post '/login' do
    UsersController.login(request)
  end

   # Routes Products
   post '/products' do
    ProductsController.create(request)
  end

  get '/products' do
    ProductsController.list
  end

  get '/openapi.yaml' do
    content_type 'application/yaml'
    headers(
      "Cache-Control" => "no-store, no-cache, must-revalidate, max-age=0",
      "Pragma" => "no-cache"
    )
    File.read(File.expand_path('../../openapi.yaml', __FILE__))
  end

  get '/AUTHORS' do
    cache_control :public, max_age: 86_400
    send_file 'AUTHORS', type: 'text/plain'
  end
end
