require 'json'
require_relative '../services/product_service'
require_relative '../schemas/product_schema'


class ProductsController
  def self.create(request)
    data = JSON.parse(request.body.read) rescue {}

    result = ProductSchema::Create.call(data)
    if result.success?
      service_result = ProductService.create(result[:name])

      if service_result[:success]
        [202, { 'content-type' => 'application/json' }, [{ message: service_result[:message] }.to_json]]
      else
        [422, { 'content-type' => 'application/json' }, [{ error: service_result[:error] }.to_json]]
      end
    else
      [422, { 'content-type' => 'application/json' }, [{ error: result.errors.to_h }.to_json]]
    end
  end

  def self.list
    result = ProductService.list
    [200, { 'content-type' => 'application/json' }, [result.to_json]]
  end
end
