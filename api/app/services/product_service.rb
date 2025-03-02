require_relative '../models/product'
require_relative '../jobs/create_product_job'

class ProductService
  def self.create(name)
    return { success: false, error: 'Name is required' } if name.nil? || name.strip.empty?

    CreateProductJob.perform_async(name)
    { success: true, message: 'Product creation enqueued' }
  end

  def self.list
    products = DB[:products].all.map(&:to_h)
    { products: products }
  end
end
