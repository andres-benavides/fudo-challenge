require_relative '../models/product'
require_relative '../jobs/create_product_job'

class ProductService
  def self.create(name)
    return { success: false, error: 'Name is required' } if name.nil? || name.strip.empty?

    CreateProductJob.perform_async(name)
    { success: true, message: 'Product creation in process' }
  end

  def self.list
    products = Product.all.map(&:to_hash)
    { products: products }
  end
end
