# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Markets', type: :request do
  before(:each) do
    @m1 = create(:market, name: 'Pallet Town', state: 'Colorado', city: 'Denver')
    @m2 = create(:market, name: 'Viridian City', state: 'Texas', city: 'Anna')
    @m3 = create(:market, name: 'Cali Town', state: 'Colorado', city: 'Springs')
  end
  context 'GET /search' do
    scenario 'returns a list of markets based on search params, state' do
    market_search_params = ({ state: 'Colorado' })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v0/markets/search', headers: headers, params: market_search_params

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    scenario 'returns a list of markets based on search params, state/city' do
      market_search_params = ({ state: 'Colorado', city: 'Denver' })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v0/markets/search', headers: headers, params: market_search_params
      return_response = JSON.parse(response.body)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(return_response['data'][0]['attributes']['name']).to eq(@m1.name)
    end

    scenario 'returns a list of markets based on search params, state/city/name' do
      market_search_params = ({ state: 'Colorado', city: 'Denver', name: 'Pallet Town' })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v0/markets/search', headers: headers, params: market_search_params
      return_response = JSON.parse(response.body)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(return_response['data'][0]['attributes']['name']).to eq(@m1.name)
    end

    scenario 'returns a list of markets based on search params, state/name' do
      market_search_params = ({ state: 'Colorado', name: 'Cali Town' })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v0/markets/search', headers: headers, params: market_search_params
      return_response = JSON.parse(response.body)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(return_response['data'][0]['attributes']['name']).to eq(@m3.name)
    end

    scenario 'returns a list of markets based on search params, name' do
      market_search_params = ({ name: 'Viridian City' })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v0/markets/search', headers: headers, params: market_search_params
      return_response = JSON.parse(response.body)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(return_response['data'][0]['attributes']['name']).to eq(@m2.name)
    end

    scenario 'cannot return a list of markets based on search params, city' do
      market_search_params = ({ city: 'Denver' })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v0/markets/search', headers: headers, params: market_search_params
      error_response = JSON.parse(response.body)
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(error_response['error']).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end

    scenario 'cannot return a list of markets based on search params, city/name' do
      market_search_params = ({ city: 'Denver', name: 'Pallet Town' })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v0/markets/search', headers: headers, params: market_search_params
      error_response = JSON.parse(response.body)
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(error_response['error']).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end
  end
end
