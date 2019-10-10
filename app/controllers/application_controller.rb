require_relative 'concerns/jwt_authentication'

class ApplicationController < ActionController::API
  include Concerns::JwtAuthentication
end
