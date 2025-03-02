require_relative './app'
Dir["./app./jobs/*.rb"].each { |file| require file }
