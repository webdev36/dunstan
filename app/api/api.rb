class API < Grape::API
  prefix 'api'
  version 'v1'
  format :json

  # load remaining API endpoints
  mount Endpoints::Account
  mount Endpoints::Keypads
end
