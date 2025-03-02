require_relative 'config/routes'

class App
  def self.call(env)
    Routes.call(env)
  end
end
