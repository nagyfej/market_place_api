Rails.application.routes.draw do

  namespase :api, defaults: {format: :json},
                  contraints: {subdomain: 'api'},
                  path: '/' do
    scope module: :v1 do
            
    end

  end

end
