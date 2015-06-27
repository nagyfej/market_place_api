require 'api_constraints'

Rails.application.routes.draw do

  devise_for :users
  namespace :api, defaults: {format: :json}, contraints: {subdomain: 'api'}, path: '/' do
    scope module: :v1, contraints: ApiConstraints.new(version: 1, default: true) do

    end
  end

end
