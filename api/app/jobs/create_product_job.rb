require 'sidekiq'
require 'sequel'
require_relative '../../websocket_server'

class CreateProductJob
  include Sidekiq::Worker
  sidekiq_options queue: :products

  def perform(name)
    product = Product.new(name: name)
    
    if product.save
      Sidekiq.logger.info "Created product: #{product.name}"
      
      begin
        message = { event: 'product_created', name: product.name }

        redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))
        redis.publish('websocket_channel', message.to_json)
        Sidekiq.logger.info "message send to Redis Pub/Sub: #{product.name}"
      rescue StandardError => e
        Sidekiq.logger.error "Error send to Redis Pub/Sub: #{e.message}"
      end
    else
      Sidekiq.logger.error "Error to save product: #{product.errors.full_messages.join(', ')}"
    end
  rescue StandardError => e
    Sidekiq.logger.error "Error in CreateProductJob: #{e.message}"
  end
end
