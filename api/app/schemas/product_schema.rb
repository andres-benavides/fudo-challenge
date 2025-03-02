require 'dry-schema'

module ProductSchema
  Create = Dry::Schema.Params do
    required(:name).filled(:string, min_size?: 3, max_size?: 100) # Nombre entre 3 y 100 caracteres
  end
end
