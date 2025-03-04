require_relative '../models/product'
require_relative '../jobs/create_product_job'
require 'logger'

class ProductService
  LOGGER = Logger.new($stdout)

  def self.create(name)
    return { success: false, error: 'Name is required' } if name.nil? || name.strip.empty?

    CreateProductJob.perform_async(name)
    { success: true, message: 'Product creation in process' }
  rescue StandardError => e
    LOGGER.error("Error creating product: #{e.message}")
    { success: false, error: 'An unexpected error occurred' }
  end

  def self.list
    products = Product.all.map(&:to_hash)
    { products: products }
  rescue StandardError => e
    LOGGER.error("Error listing products: #{e.message}")
    { success: false, error: 'An unexpected error occurred' }
  end
end
