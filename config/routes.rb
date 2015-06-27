Rails.application.routes.draw do

  namespase :api, defaults: {format: :json},
                  contraints: {subdomain: 'api'},
                  path: '/' do

  end

end
