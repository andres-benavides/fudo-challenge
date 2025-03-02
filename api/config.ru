require_relative './app'
require_relative './app/middlewares/auth_middleware'
require_relative './websocket_server'

run Routes
use Rack::Deflater
use Rack::CommonLogger
use AuthMiddleware
map '/ws' do
  run WebSocketServer
end
run App