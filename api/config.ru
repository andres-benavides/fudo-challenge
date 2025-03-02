require_relative './app'
require_relative './app/middlewares/auth_middleware'
require_relative './websocket_server'

use Rack::Deflater
use AuthMiddleware
map '/ws' do
  run WebSocketServer
end
run App