require 'jwt'

class TokenService
  SECRET_KEY = ENV['JWT_SECRET'] || 'super_secret_key'

  def self.encode(payload, exp = Time.now + 24 * 3600)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithms: ['HS256'])[0]
    decoded.transform_keys(&:to_sym)
  rescue JWT::DecodeError => e
    puts "JWT Decode Error: #{e.message}"
    nil
  end
end
