require_relative '../services/token_service'

class AuthMiddleware
  def initialize(app)
    @app = app
    @exclude_routes = %w[/login /signup /openapi.yaml /AUTHORS /ws]
  end

  def call(env)
    req = Rack::Request.new(env)
    return @app.call(env) if @exclude_routes.include? req.path

    auth_header = req.env['HTTP_AUTHORIZATION']
    token = auth_header&.split(' ')&.last

    if token && (decoded = TokenService.decode(token))
      
      env['user_id'] = decoded['user_id']
      @app.call(env)
    else
      [401, { 'content-type' => 'application/json' }, [{ error: 'Unauthorized' }.to_json]]
    end
  end
end
