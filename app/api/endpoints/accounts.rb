module Endpoints
  class Accounts < Grape::API

    resource :accounts do

      # Accounts API test
      # /api/v1/accounts/ping
      # results  'gwangming'
      get :ping do
        { :ping => 'account api working now' }
      end

    end
  end
end
