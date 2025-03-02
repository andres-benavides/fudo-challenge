require 'faye/websocket'
require 'redis'
require 'thread'
require 'json'

class WebSocketServer
  puts "🔍 REDIS_URL: #{ENV['REDIS_URL']}"
  KEEPALIVE_TIME = 15
  @clients = []
  @redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))

  def self.call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env, nil, { ping: KEEPALIVE_TIME })
      @clients << ws

      ws.on :message do |event|
        puts ": #{event.data}"
      end

      ws.on :close do |_event|
        @clients.delete(ws)
        ws = nil
      end

      response = ws.rack_response
  
      if response.is_a?(Array) && response.length == 3 && response[0].is_a?(Integer) && response[0] >= 100
        return response
      else
        return [101, { 'upgrade' => 'websocket', 'connection' => 'upgrade' }, []]
      end
      
    else
      return [400, { 'Content-Type' => 'text/plain' }, ['Bad Request']]
    end
  end

  def self.broadcast(message)
    @clients.each do |client|
      client.send(message.to_json) if client.ready_state == Faye::WebSocket::OPEN
    end
  end

  def self.listen_to_redis
    Thread.new do
      Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')).subscribe('websocket_channel') do |on|
        on.message do |_channel, message|
          puts "🔔 Mensaje recibido desde Redis: #{message}"
          broadcast(JSON.parse(message))
        end
      end
    end
  end
end


WebSocketServer.listen_to_redis
