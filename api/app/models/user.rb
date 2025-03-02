require_relative '../../config/database'
require 'bcrypt'

class User < Sequel::Model
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  def validate
    super
    validates_presence [:email, :password_digest]
    validates_unique :email
  end

  def password=(new_password)
    self.password_digest = BCrypt::Password.create(new_password)
  end

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end
end
