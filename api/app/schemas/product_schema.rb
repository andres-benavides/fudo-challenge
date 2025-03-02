require 'dry-schema'

module ProductSchema
  Create = Dry::Schema.Params do
    required(:name).filled(:string, min_size?: 3, max_size?: 100)
  end
end
