require_relative '../../config/database'

class Product < Sequel::Model
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name]
  end
end
