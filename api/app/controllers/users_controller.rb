require 'json'
require_relative '../services/auth_service'
require_relative '../schemas/auth_schema'

class UsersController
  def self.register(request)
    data = JSON.parse(request.body.read) rescue {}

    result = AuthSchema::Register.call(data)
 
    if result.success?
      service_result = AuthService.register(result[:email], result[:password])

      if service_result[:success]
        [201, { 'content-type' => 'application/json' }, [{ message: 'User created' }.to_json]]
      else
        [422, { 'content-type' => 'application/json' }, [{ error: service_result[:errors] }.to_json]]
      end
    else
      [422, { 'content-type' => 'application/json' }, [{ error: result.errors.to_h }.to_json]]
    end
  end

  def self.login(request)
    p "NO TEST IN HERE"
    data = JSON.parse(request.body.read) rescue {}

    result = AuthSchema::Login.call(data)

    if result.success?
      service_result = AuthService.login(result[:email], result[:password])

      if service_result[:success]
        [200, { 'content-type' => 'application/json' }, [{ token: service_result[:token] }.to_json]]
      else
        [401, { 'content-type' => 'application/json' }, [{ error: service_result[:error] }.to_json]]
      end
    else
      [422, { 'content-type' => 'application/json' }, [{ error: result.errors.to_h }.to_json]]
    end
  end
end
