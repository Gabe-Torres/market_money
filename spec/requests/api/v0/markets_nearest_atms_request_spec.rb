require 'rails_helper'

RSpec.describe 'Markets nearest ATMs ', type: :request do
  context 'GET /nearest_atms' do
    scenario 'atms near the location of market' do
      market = create(:market, id: 1, lat: "42.2031602", lon: "-83.1500042")

      get "/api/v0/markets/#{market[:id]}/nearest_atms"

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(result[0][:type]).to eq("atm")
      expect(result[0][:attributes][:name]).to eq("ATM")
    end
  end

  context 'happy and sad paths for GET /nearest_atms' do
    scenario 'happy path, returns code 200' do
      market = create(:market, id: 1, lat: "42.2031602", lon: "-83.1500042")

      get "/api/v0/markets/#{market[:id]}/nearest_atms"

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    scenario 'sad path, returns code 404' do  
      get "/api/v0/markets/123123123123/nearest_atms"

      error_response = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(response.status).to eq(404)
      expect { Market.find(123123123123) }.to raise_error { ActiveRecord::RecordNotFound }
      expect(error_response['errors']).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end
end
