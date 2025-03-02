require 'dry-schema'

module AuthSchema
  Register = Dry::Schema.Params do
    required(:email).filled(:str?, format?: /\A[^@\s]+@[^@\s]+\z/)
    required(:password).filled(:str?, min_size?: 6)
  end

  Login = Dry::Schema.Params do
    required(:email).filled(:str?, format?: /\A[^@\s]+@[^@\s]+\z/)
    required(:password).filled(:str?)
  end
end
