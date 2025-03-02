require 'jwt'
require_relative '../models/user'
require_relative './token_service'

class AuthService
  def self.register(email, password)
    user = User.new(email: email)
    user.password = password

    if user.save
      { success: true, user: user }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end

  def self.login(email, password)

    begin
      user = User.first(email: email)
      return { success: false, error: 'Invalid credentials' } unless user&.authenticate(password)

      token = TokenService.encode({ user_id: user.id })
      { success: true, token: token }
    rescue StandardError => e
      { success: false, error: e.message }
    end
  end

  def self.decode_token(token)
    TokenService.decode(token)
  end
end

